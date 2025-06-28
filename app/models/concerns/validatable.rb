module Validatable
  extend ActiveSupport::Concern

  # 分離されたモジュールを読み込み
  include RegexPatterns

  class_methods do
    def model_name_for_validation
      name.demodulize.downcase
    end

    def get_display_name_for_attribute(attribute_name)
      ConfigurationManager.get_display_name(model_name_for_validation, attribute_name)
    end

    def get_validation_message(message_key, interpolations = {})
      MessageManager.get_formatted_message(message_key, interpolations)
    end

    def validate_attribute_is_managed!(attribute_name)
      ConfigurationManager.validate_attribute_managed!(model_name_for_validation, attribute_name)
    end

    # === 共通バリデーション処理メソッド ===

    # 属性に対する共通バリデーション前処理
    # @param attribute [Symbol] 属性名
    # @param message_key [Symbol] メッセージキー
    # @return [Hash] display_name と message を含むハッシュ
    private def prepare_validation_for_attribute(attribute, message_key, interpolations = {})
      validate_attribute_is_managed!(attribute)
      {
        display_name: get_display_name_for_attribute(attribute),
        message: get_validation_message(message_key, interpolations)
      }
    end

    # 複数属性に対するフォーマットバリデーション共通処理
    # @param attributes [Array<Symbol>] 属性名配列
    # @param message_key [Symbol] メッセージキー
    # @param regex_pattern [Regexp] 正規表現パターン
    # @param options [Hash] バリデーションオプション
    private def validates_format_for_attributes(attributes, message_key, regex_pattern, **options)
      attributes.each do |attribute|
        validation_data = prepare_validation_for_attribute(attribute, message_key)

        validates attribute, format: {
          with: regex_pattern,
          message: "#{validation_data[:display_name]}#{validation_data[:message]}"
        }.merge(options)
      end
    end

    # 複数属性に対するプレゼンスバリデーション共通処理
    # @param attributes [Array<Symbol>] 属性名配列
    # @param message_key [Symbol] メッセージキー
    # @param options [Hash] バリデーションオプション
    private def validates_presence_for_attributes(attributes, message_key, **options)
      attributes.each do |attribute|
        validation_data = prepare_validation_for_attribute(attribute, message_key)

        validates attribute, presence: {
          message: "#{validation_data[:display_name]}#{validation_data[:message]}"
        }.merge(options)
      end
    end

    # 複数属性に対するユニークネスバリデーション共通処理
    # @param attributes [Array<Symbol>] 属性名配列
    # @param message_key [Symbol] メッセージキー
    # @param options [Hash] バリデーションオプション
    private def validates_uniqueness_for_attributes(attributes, message_key, **options)
      attributes.each do |attribute|
        validation_data = prepare_validation_for_attribute(attribute, message_key)

        validates attribute, uniqueness: {
          message: "#{validation_data[:display_name]}#{validation_data[:message]}"
        }.merge(options)
      end
    end

    # === 正規表現ベースのバリデーションメソッド ===

    # 日本語名バリデーション
    def validates_japanese_name(*attributes, **options)
      validates_format_for_attributes(attributes, :japanese_name, JAPANESE_NAME_FORMAT, **options)
    end

    # メールアドレスバリデーション
    def validates_email(*attributes, **options)
      validates_format_for_attributes(attributes, :email, EMAIL_FORMAT, **options)
    end

    # 電話番号バリデーション
    def validates_phone(*attributes, **options)
      validates_format_for_attributes(attributes, :phone, PHONE_FORMAT, **options)
    end

    # 携帯電話番号バリデーション
    def validates_mobile_phone(*attributes, **options)
      validates_format_for_attributes(attributes, :mobile_phone, MOBILE_PHONE_FORMAT, **options)
    end

    # 英数字バリデーション
    def validates_alphanumeric(*attributes, **options)
      validates_format_for_attributes(attributes, :alphanumeric, ALPHANUMERIC_FORMAT, **options)
    end

    # ユーザー名バリデーション
    def validates_username(*attributes, **options)
      validates_format_for_attributes(attributes, :username, USERNAME_FORMAT, **options)
    end

    # URL バリデーション
    def validates_url(*attributes, **options)
      validates_format_for_attributes(attributes, :url, URL_FORMAT, **options)
    end

    # 強いパスワードバリデーション
    def validates_strong_password(*attributes, **options)
      validates_format_for_attributes(attributes, :strong_password, STRONG_PASSWORD_FORMAT, **options)
    end

    # 必須バリデーション
    def validates_required(*attributes, **options)
      validates_presence_for_attributes(attributes, :presence, **options)
    end

    # 一意性バリデーション
    def validates_unique(*attributes, **options)
      validates_uniqueness_for_attributes(attributes, :taken, **options)
    end

    # 文字数制限バリデーション
    def validates_length_with_message(attribute, min: nil, max: nil, **options)
      validation_data = prepare_validation_for_attribute(attribute, :presence) # ダミーキー

      length_options = {}
      if max
        length_options[:maximum] = max
        length_options[:too_long] = "#{validation_data[:display_name]}#{get_validation_message(:too_long, count: max)}"
      end
      if min
        length_options[:minimum] = min
        length_options[:too_short] = "#{validation_data[:display_name]}#{get_validation_message(:too_short, count: min)}"
      end

      validates attribute, length: length_options.merge(options)
    end
  end
end