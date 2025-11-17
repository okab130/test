# ECサイト注文処理システム - C4モデル

## C4モデルとは
C4モデルは、ソフトウェアアーキテクチャを4つのレベル（Context、Container、Component、Code）で段階的に詳細化していく手法です。

---

## レベル1: システムコンテキスト図
**誰がシステムを使うのか、どの外部システムと連携するのかを俯瞰**

```mermaid
graph TB
    %% 人物
    Customer([顧客<br/>Person])
    Admin([管理者<br/>Person])
    Warehouse([倉庫担当者<br/>Person])
    
    %% メインシステム
    ECSystem[ECサイト<br/>注文処理システム<br/>Software System]
    
    %% 外部システム
    PaymentGW[決済ゲートウェイ<br/>External System]
    DeliveryAPI[配送業者API<br/>External System]
    EmailService[メール送信サービス<br/>External System]
    InventorySystem[在庫管理システム<br/>External System]
    
    %% 関係性
    Customer -->|商品閲覧、注文、<br/>配送状況確認| ECSystem
    ECSystem -->|注文確認メール、<br/>配送通知| Customer
    
    Admin -->|商品登録、<br/>注文管理| ECSystem
    
    Warehouse -->|出荷処理、<br/>在庫更新| ECSystem
    
    ECSystem -->|決済要求<br/>カード情報| PaymentGW
    PaymentGW -->|決済結果<br/>承認番号| ECSystem
    
    ECSystem -->|配送依頼<br/>配送先情報| DeliveryAPI
    DeliveryAPI -->|配送番号<br/>配送状況| ECSystem
    
    ECSystem -->|メール送信要求| EmailService
    EmailService -->|送信結果| ECSystem
    
    ECSystem -->|在庫照会<br/>引当要求| InventorySystem
    InventorySystem -->|在庫情報<br/>引当結果| ECSystem
    
    style ECSystem fill:#1168bd,stroke:#0b4884,color:#ffffff
    style Customer fill:#08427b,stroke:#052e56,color:#ffffff
    style Admin fill:#08427b,stroke:#052e56,color:#ffffff
    style Warehouse fill:#08427b,stroke:#052e56,color:#ffffff
    style PaymentGW fill:#999999,stroke:#6b6b6b,color:#ffffff
    style DeliveryAPI fill:#999999,stroke:#6b6b6b,color:#ffffff
    style EmailService fill:#999999,stroke:#6b6b6b,color:#ffffff
    style InventorySystem fill:#999999,stroke:#6b6b6b,color:#ffffff
```

### システムコンテキスト図の説明

| 要素 | タイプ | 説明 |
|-----|--------|------|
| 顧客 | Person | ECサイトで商品を購入するエンドユーザー |
| 管理者 | Person | 商品や注文を管理する内部ユーザー |
| 倉庫担当者 | Person | 出荷処理と在庫を管理する内部ユーザー |
| ECサイト注文処理システム | Software System | 本システム（注文受付から配送まで管理） |
| 決済ゲートウェイ | External System | クレジットカード決済を処理する外部サービス |
| 配送業者API | External System | 配送手配と追跡を行う外部サービス |
| メール送信サービス | External System | トランザクションメールを送信する外部サービス |
| 在庫管理システム | External System | 倉庫の在庫をリアルタイムで管理する既存システム |

---

## レベル2: コンテナ図
**システム内部の主要なアプリケーションとデータストアの構成**

```mermaid
graph TB
    %% 外部アクター
    Customer([顧客])
    Admin([管理者])
    Warehouse([倉庫担当者])
    
    %% 外部システム
    PaymentGW[決済ゲートウェイ]
    DeliveryAPI[配送業者API]
    EmailService[メール送信サービス]
    InventorySystem[在庫管理システム]
    
    subgraph ECサイト注文処理システム
        WebApp[Webアプリケーション<br/>Container: React SPA<br/>ユーザーインターフェース]
        
        AdminApp[管理画面<br/>Container: React SPA<br/>管理者用インターフェース]
        
        APIGateway[APIゲートウェイ<br/>Container: Node.js/Express<br/>APIルーティング・認証]
        
        OrderService[注文サービス<br/>Container: Java/Spring Boot<br/>注文処理ビジネスロジック]
        
        ProductService[商品サービス<br/>Container: Java/Spring Boot<br/>商品管理ビジネスロジック]
        
        PaymentService[決済サービス<br/>Container: Java/Spring Boot<br/>決済処理ビジネスロジック]
        
        NotificationService[通知サービス<br/>Container: Node.js<br/>メール・プッシュ通知]
        
        OrderDB[(注文DB<br/>Container: PostgreSQL<br/>注文・配送データ)]
        
        ProductDB[(商品DB<br/>Container: PostgreSQL<br/>商品・在庫データ)]
        
        CustomerDB[(顧客DB<br/>Container: PostgreSQL<br/>顧客・会員データ)]
        
        Cache[(キャッシュ<br/>Container: Redis<br/>セッション・商品情報)]
        
        MessageQueue[メッセージキュー<br/>Container: RabbitMQ<br/>非同期処理]
    end
    
    %% 顧客の関係性
    Customer -->|HTTPS| WebApp
    WebApp -->|JSON/HTTPS| APIGateway
    
    %% 管理者の関係性
    Admin -->|HTTPS| AdminApp
    Warehouse -->|HTTPS| AdminApp
    AdminApp -->|JSON/HTTPS| APIGateway
    
    %% API Gateway
    APIGateway -->|REST API| OrderService
    APIGateway -->|REST API| ProductService
    APIGateway -->|REST API| PaymentService
    APIGateway <-->|セッション管理| Cache
    
    %% Order Service
    OrderService -->|JDBC| OrderDB
    OrderService -->|REST API| InventorySystem
    OrderService -->|Pub/Sub| MessageQueue
    
    %% Product Service
    ProductService -->|JDBC| ProductDB
    ProductService <-->|キャッシュ| Cache
    
    %% Payment Service
    PaymentService -->|HTTPS| PaymentGW
    PaymentService -->|JDBC| OrderDB
    PaymentService -->|Pub/Sub| MessageQueue
    
    %% Notification Service
    MessageQueue -->|Subscribe| NotificationService
    NotificationService -->|SMTP/API| EmailService
    NotificationService -->|JDBC| CustomerDB
    
    %% Delivery Integration
    OrderService -->|REST API| DeliveryAPI
    
    style WebApp fill:#438dd5,stroke:#2e6295,color:#ffffff
    style AdminApp fill:#438dd5,stroke:#2e6295,color:#ffffff
    style APIGateway fill:#438dd5,stroke:#2e6295,color:#ffffff
    style OrderService fill:#438dd5,stroke:#2e6295,color:#ffffff
    style ProductService fill:#438dd5,stroke:#2e6295,color:#ffffff
    style PaymentService fill:#438dd5,stroke:#2e6295,color:#ffffff
    style NotificationService fill:#438dd5,stroke:#2e6295,color:#ffffff
    style OrderDB fill:#82b366,stroke:#5d7f4a,color:#ffffff
    style ProductDB fill:#82b366,stroke:#5d7f4a,color:#ffffff
    style CustomerDB fill:#82b366,stroke:#5d7f4a,color:#ffffff
    style Cache fill:#82b366,stroke:#5d7f4a,color:#ffffff
    style MessageQueue fill:#f4a460,stroke:#c77e3a,color:#ffffff
```

### コンテナ図の説明

| コンテナ | 技術 | 責務 |
|---------|------|------|
| Webアプリケーション | React SPA | 顧客向けUI（商品閲覧、カート、注文） |
| 管理画面 | React SPA | 管理者・倉庫担当者向けUI |
| APIゲートウェイ | Node.js/Express | 認証、ルーティング、レート制限 |
| 注文サービス | Java/Spring Boot | 注文受付、在庫確認、配送手配 |
| 商品サービス | Java/Spring Boot | 商品CRUD、カテゴリ管理 |
| 決済サービス | Java/Spring Boot | 決済処理、トランザクション管理 |
| 通知サービス | Node.js | メール送信、通知管理 |
| 注文DB | PostgreSQL | 注文、配送、決済データの永続化 |
| 商品DB | PostgreSQL | 商品、カテゴリ、在庫データ |
| 顧客DB | PostgreSQL | 顧客情報、配送先、購入履歴 |
| キャッシュ | Redis | セッション、商品情報のキャッシュ |
| メッセージキュー | RabbitMQ | 非同期処理（メール送信、在庫更新） |

---

## レベル3: コンポーネント図（注文サービスの詳細）
**注文サービス内部の主要コンポーネント**

```mermaid
graph TB
    APIGateway[APIゲートウェイ]
    
    subgraph 注文サービス
        OrderController[注文コントローラー<br/>Component<br/>REST APIエンドポイント]
        
        OrderFacade[注文ファサード<br/>Component<br/>ビジネスフロー制御]
        
        InventoryChecker[在庫確認<br/>Component<br/>在庫確認ロジック]
        
        OrderValidator[注文検証<br/>Component<br/>注文データ検証]
        
        OrderRepository[注文リポジトリ<br/>Component<br/>データアクセス]
        
        PaymentIntegration[決済連携<br/>Component<br/>決済サービス呼び出し]
        
        DeliveryIntegration[配送連携<br/>Component<br/>配送API呼び出し]
        
        EventPublisher[イベント発行<br/>Component<br/>メッセージ発行]
        
        OrderStateMachine[注文状態機械<br/>Component<br/>ステータス遷移管理]
    end
    
    OrderDB[(注文DB)]
    InventorySystem[在庫管理システム]
    PaymentService[決済サービス]
    DeliveryAPI[配送業者API]
    MessageQueue[メッセージキュー]
    
    APIGateway -->|注文要求| OrderController
    OrderController -->|委譲| OrderFacade
    
    OrderFacade -->|検証| OrderValidator
    OrderFacade -->|在庫確認| InventoryChecker
    OrderFacade -->|決済処理| PaymentIntegration
    OrderFacade -->|配送手配| DeliveryIntegration
    OrderFacade -->|永続化| OrderRepository
    OrderFacade -->|イベント発行| EventPublisher
    OrderFacade -->|状態管理| OrderStateMachine
    
    InventoryChecker -->|在庫照会| InventorySystem
    PaymentIntegration -->|決済要求| PaymentService
    DeliveryIntegration -->|配送依頼| DeliveryAPI
    
    OrderRepository -->|JDBC| OrderDB
    EventPublisher -->|Publish| MessageQueue
    
    style OrderController fill:#85bbf0,stroke:#5d8ab8,color:#000000
    style OrderFacade fill:#85bbf0,stroke:#5d8ab8,color:#000000
    style InventoryChecker fill:#85bbf0,stroke:#5d8ab8,color:#000000
    style OrderValidator fill:#85bbf0,stroke:#5d8ab8,color:#000000
    style OrderRepository fill:#85bbf0,stroke:#5d8ab8,color:#000000
    style PaymentIntegration fill:#85bbf0,stroke:#5d8ab8,color:#000000
    style DeliveryIntegration fill:#85bbf0,stroke:#5d8ab8,color:#000000
    style EventPublisher fill:#85bbf0,stroke:#5d8ab8,color:#000000
    style OrderStateMachine fill:#85bbf0,stroke:#5d8ab8,color:#000000
```

---

## 統合ビュー: データ・イベント・物の流れ

```mermaid
graph LR
    subgraph 顧客側
        Customer([顧客])
    end
    
    subgraph ECサイトシステム
        direction TB
        WebUI[Webアプリ]
        API[APIゲートウェイ]
        OrderSvc[注文サービス]
        ProductSvc[商品サービス]
        PaymentSvc[決済サービス]
        NotifySvc[通知サービス]
        
        OrderDB[(注文DB)]
        ProductDB[(商品DB)]
        Queue[メッセージキュー]
    end
    
    subgraph 外部システム
        Payment[決済GW]
        Delivery[配送業者]
        Email[メール]
        Inventory[在庫システム]
    end
    
    subgraph 物理世界
        Warehouse([倉庫])
        DeliveryTruck([配送トラック])
        CustomerHome([顧客の自宅])
    end
    
    %% データフロー
    Customer -->|①注文データ| WebUI
    WebUI -->|②API呼び出し| API
    API -->|③注文処理| OrderSvc
    OrderSvc <-->|④在庫確認| Inventory
    OrderSvc -->|⑤決済要求| PaymentSvc
    PaymentSvc <-->|⑥決済処理| Payment
    OrderSvc -->|⑦注文確定| OrderDB
    OrderSvc -->|⑧イベント発行| Queue
    Queue -->|⑨通知要求| NotifySvc
    NotifySvc -->|⑩メール送信| Email
    Email -->|⑪確認メール| Customer
    OrderSvc -->|⑫配送依頼| Delivery
    
    %% 物の流れ
    Delivery -.->|⑬出荷指示| Warehouse
    Warehouse -.->|⑭商品ピッキング| DeliveryTruck
    DeliveryTruck -.->|⑮配送| CustomerHome
    
    style Customer fill:#08427b,stroke:#052e56,color:#ffffff
    style Warehouse fill:#d4a574,stroke:#9d7a54,color:#000000
    style DeliveryTruck fill:#d4a574,stroke:#9d7a54,color:#000000
    style CustomerHome fill:#d4a574,stroke:#9d7a54,color:#000000
```

### データ・イベント・物の流れの説明

| フェーズ | データの流れ | イベント | 物の流れ |
|---------|------------|---------|---------|
| ①-② | 注文データ送信 | 注文開始イベント | - |
| ③-④ | 在庫確認API呼び出し | 在庫確認イベント | - |
| ⑤-⑥ | 決済データ送信・受信 | 決済完了イベント | - |
| ⑦ | 注文データDB保存 | 注文確定イベント | - |
| ⑧-⑨ | メッセージキュー経由 | 通知要求イベント | - |
| ⑩-⑪ | メール送信 | メール送信完了イベント | - |
| ⑫ | 配送依頼データ送信 | 配送手配イベント | - |
| ⑬ | 出荷指示データ | 出荷指示イベント | 伝票発行 |
| ⑭ | - | ピッキング完了イベント | 商品梱包・出荷 |
| ⑮ | 配送追跡データ更新 | 配送中・配送完了イベント | 商品配送 |

---

## イベント駆動アーキテクチャ

```mermaid
sequenceDiagram
    participant C as 顧客
    participant W as Webアプリ
    participant O as 注文サービス
    participant P as 決済サービス
    participant Q as メッセージキュー
    participant N as 通知サービス
    participant D as 配送API
    participant WH as 倉庫システム
    
    C->>W: 注文送信
    W->>O: 注文作成API
    
    Note over O: ①注文検証
    O->>O: 在庫確認
    
    O->>P: 決済要求
    P->>P: 決済処理
    P-->>O: 決済完了
    
    Note over O: ②注文確定
    O->>Q: OrderConfirmedEvent発行
    O-->>W: 注文番号返却
    W-->>C: 注文完了画面表示
    
    Q->>N: OrderConfirmedEvent受信
    N->>C: 注文確認メール送信
    
    O->>D: 配送依頼
    D-->>O: 配送番号返却
    O->>Q: ShipmentRequestedEvent発行
    
    Q->>WH: ShipmentRequestedEvent受信
    WH->>WH: ピッキングリスト生成
    
    Note over WH: ③商品ピッキング・梱包
    WH->>D: 出荷完了通知
    D->>Q: ShipmentStartedEvent発行
    
    Q->>N: ShipmentStartedEvent受信
    N->>C: 発送完了メール送信
    
    Note over D: ④配送中
    D->>Q: DeliveredEvent発行
    
    Q->>N: DeliveredEvent受信
    N->>C: 配送完了メール送信
```

---

## システムアーキテクチャの特徴

### 1. マイクロサービスアーキテクチャ
- 注文、商品、決済を独立したサービスとして分離
- 各サービスは独自のデータベースを持つ（Database per Service）
- サービス間の疎結合を実現

### 2. イベント駆動設計
- メッセージキューによる非同期処理
- 注文確定、配送開始などの重要イベントを発行
- システム間の依存関係を削減

### 3. API Gatewayパターン
- クライアントとサービス間の単一エントリーポイント
- 認証・認可の一元管理
- レート制限、ロギング、モニタリング

### 4. キャッシング戦略
- Redisによる商品情報、セッション情報のキャッシュ
- データベース負荷の軽減
- レスポンス速度の向上

### 5. 外部システム連携
- 決済ゲートウェイ：PCI DSS準拠の外部サービス利用
- 配送業者API：リアルタイム配送追跡
- 在庫管理システム：既存システムとのREST API連携

---

## 非機能要件の実現方法

| 要件 | 実現方法 |
|-----|---------|
| **可用性** | ロードバランサー、複数インスタンス、ヘルスチェック |
| **拡張性** | 水平スケーリング、マイクロサービス、キャッシュ |
| **パフォーマンス** | Redis キャッシュ、DB インデックス、CDN |
| **セキュリティ** | HTTPS、JWT認証、APIキー管理、入力検証 |
| **監視** | ログ集約、メトリクス収集、分散トレーシング |
| **障害対応** | サーキットブレーカー、リトライ、タイムアウト |
| **データ整合性** | トランザクション、Saga パターン、イベントソーシング |

---

## デプロイメント図（参考）

```mermaid
graph TB
    subgraph インターネット
        Users([ユーザー])
    end
    
    subgraph AWS / クラウド環境
        subgraph CDN
            CloudFront[CloudFront<br/>静的コンテンツ配信]
        end
        
        subgraph Webレイヤー
            ALB[Application Load Balancer]
            WebApp1[Webアプリ<br/>インスタンス1]
            WebApp2[Webアプリ<br/>インスタンス2]
        end
        
        subgraph APIレイヤー
            APIGW[API Gateway]
            Order1[注文サービス<br/>インスタンス1]
            Order2[注文サービス<br/>インスタンス2]
            Product1[商品サービス<br/>インスタンス1]
            Payment1[決済サービス<br/>インスタンス1]
        end
        
        subgraph データレイヤー
            RDS[(RDS PostgreSQL<br/>Multi-AZ)]
            ElastiCache[(ElastiCache<br/>Redis)]
            RabbitMQ[RabbitMQ<br/>クラスタ]
        end
    end
    
    Users -->|HTTPS| CloudFront
    CloudFront --> ALB
    ALB --> WebApp1
    ALB --> WebApp2
    
    WebApp1 --> APIGW
    WebApp2 --> APIGW
    
    APIGW --> Order1
    APIGW --> Order2
    APIGW --> Product1
    APIGW --> Payment1
    
    Order1 --> RDS
    Order2 --> RDS
    Product1 --> RDS
    Payment1 --> RDS
    
    Product1 <--> ElastiCache
    APIGW <--> ElastiCache
    
    Order1 --> RabbitMQ
    Payment1 --> RabbitMQ
```

---

## まとめ

このC4モデルドキュメントは、ECサイト注文処理システムを以下の観点で包括的に表現しています：

### ✅ 含まれる要素
- **データの流れ**: API呼び出し、DB操作、メッセージング
- **データベース**: 注文DB、商品DB、顧客DB、キャッシュ
- **顧客**: 顧客、管理者、倉庫担当者
- **イベント**: 注文確定、決済完了、配送開始などのビジネスイベント
- **物の流れ**: 倉庫からのピッキング、配送、顧客への到着
- **プロセス**: 注文受付、在庫確認、決済、配送手配
- **外部システム**: 決済GW、配送API、在庫システム、メールサービス

### 📊 4つのレベル
1. **コンテキスト図**: システム全体の俯瞰
2. **コンテナ図**: 技術スタックと主要コンポーネント
3. **コンポーネント図**: サービス内部の詳細設計
4. **統合ビュー**: データ・イベント・物の流れの統合表現

このドキュメントを使用することで、ステークホルダー全員が同じシステムイメージを共有できます。
