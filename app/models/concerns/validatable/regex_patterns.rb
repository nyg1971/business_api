module Validatable
  module RegexPatterns
    # === 日本語系正規表現 ===
    # ひらがな・カタカナ・漢字・英数字・ハイフン・長音符・スペース
    JAPANESE_NAME_FORMAT = /\A[\p{Hiragana}\p{Katakana}\p{Han}a-zA-Z0-9\s\-ー]+\z/.freeze

    # 住所用（括弧も含む）
    JAPANESE_ADDRESS_FORMAT = /\A[\p{Hiragana}\p{Katakana}\p{Han}a-zA-Z0-9\s\-ー０-９（）()]+\z/.freeze

    # カタカナのみ（フリガナ等）
    KATAKANA_FORMAT = /\A[\p{Katakana}ー\s]+\z/.freeze

    # ひらがなのみ
    HIRAGANA_FORMAT = /\A[\p{Hiragana}\s]+\z/.freeze

    # === 連絡先系正規表現 ===
    # メールアドレス（RFC準拠の簡易版）
    EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

    # 電話番号（ハイフン区切り）
    PHONE_FORMAT = /\A\d{2,4}-\d{2,4}-\d{4}\z/.freeze

    # 携帯電話（より厳密）
    MOBILE_PHONE_FORMAT = /\A0[789]0-\d{4}-\d{4}\z/.freeze

    # 郵便番号（日本形式）
    POSTAL_CODE_FORMAT = /\A\d{3}-\d{4}\z/.freeze

    # === 識別子系正規表現 ===
    # 英数字のみ（ID・コード等）
    ALPHANUMERIC_FORMAT = /\A[a-zA-Z0-9]+\z/.freeze

    # 英数字とハイフン・アンダースコア（ユーザー名等）
    USERNAME_FORMAT = /\A[a-zA-Z0-9\-_]+\z/.freeze

    # 英字のみ
    ALPHA_FORMAT = /\A[a-zA-Z]+\z/.freeze

    # 数字のみ
    NUMERIC_FORMAT = /\A\d+\z/.freeze

    # === URL・ウェブ系正規表現 ===
    # URL（http/https）
    URL_FORMAT = /\Ahttps?:\/\/[\w\/:%#\$&\?\(\)~\.=\+\-]+\z/.freeze

    # ドメイン名
    DOMAIN_FORMAT = /\A[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}\z/.freeze

    # === 金融・ビジネス系正規表現 ===
    # クレジットカード番号（基本形）
    CREDIT_CARD_FORMAT = /\A\d{4}-\d{4}-\d{4}-\d{4}\z/.freeze

    # 銀行口座番号（7桁）
    BANK_ACCOUNT_FORMAT = /\A\d{7}\z/.freeze

    # === パスワード系正規表現 ===
    # 強いパスワード（英大小数字記号を含む8文字以上）
    STRONG_PASSWORD_FORMAT = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}\z/.freeze

    # 中程度パスワード（英数字8文字以上）
    MEDIUM_PASSWORD_FORMAT = /\A[a-zA-Z\d]{8,}\z/.freeze

    # === 全パターン一覧取得 ===
    def self.all_patterns
      constants.select { |const| const.to_s.end_with?('_FORMAT') }
               .map { |const| [const, const_get(const)] }
               .to_h
    end

    def self.list_all_patterns
      puts "=== 利用可能な正規表現パターン ==="
      all_patterns.each do |name, pattern|
        puts "#{name.to_s.ljust(30)} : #{pattern.source}"
      end
    end

    def self.test_pattern(pattern_name, test_string)
      pattern = const_get(pattern_name)
      result = test_string.match?(pattern)
      puts "#{pattern_name}: '#{test_string}' => #{result ? '✅ マッチ' : '❌ 不一致'}"
    rescue NameError
      puts "❌ パターン '#{pattern_name}' が見つかりません"
    end
  end
end