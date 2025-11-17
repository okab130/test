# ECサイト注文処理システム - スイムレーン図 (Swim Lane Diagram)

## スイムレーン図とは
プロセスの各ステップを担当者や部門ごとに「レーン（泳ぐコース）」に分けて表現する手法です。責任の所在とプロセスの流れを同時に可視化できます。

---

## スイムレーン図：注文から配送完了まで（全体フロー）

```mermaid
graph TB
    subgraph 顧客レーン
        direction TB
        C1[商品閲覧]
        C2[カートに追加]
        C3[配送先・支払情報入力]
        C4[注文確定ボタン押下]
        C5[注文確認メール受信]
        C6[発送通知メール受信]
        C7[商品受取]
        C8[配送完了メール受信]
    end
    
    subgraph Webアプリケーションレーン
        direction TB
        W1[商品一覧表示]
        W2[カート更新]
        W3[入力フォーム表示]
        W4[入力検証]
        W5[注文API呼出]
        W6[処理中画面表示]
        W7[注文完了画面表示]
    end
    
    subgraph 注文サービスレーン
        direction TB
        O1[注文受付]
        O2[在庫確認API呼出]
        O3[決済API呼出]
        O4[注文DB保存]
        O5[注文確定イベント発行]
        O6[配送API呼出]
        O7[配送情報DB保存]
    end
    
    subgraph 在庫管理システムレーン
        direction TB
        I1[在庫照会]
        I2{在庫あり?}
        I3[在庫引当]
        I4[在庫情報返却]
    end
    
    subgraph 決済ゲートウェイレーン
        direction TB
        P1[決済要求受信]
        P2[カード認証]
        P3{認証成功?}
        P4[決済実行]
        P5[決済結果返却]
    end
    
    subgraph 通知サービスレーン
        direction TB
        N1[イベント受信]
        N2[メールテンプレート生成]
        N3[メール送信API呼出]
        N4[SMS送信API呼出]
    end
    
    subgraph 配送業者APIレーン
        direction TB
        D1[配送依頼受信]
        D2[配送番号発行]
        D3[配送番号返却]
        D4[倉庫に出荷指示]
        D5[配送ステータス更新]
    end
    
    subgraph 倉庫担当者レーン
        direction TB
        WH1[ピッキングリスト確認]
        WH2[商品ピッキング]
        WH3[検品・梱包]
        WH4[配送業者に引渡]
        WH5[出荷完了登録]
    end
    
    subgraph 配送ドライバーレーン
        direction TB
        DR1[荷物受取]
        DR2[配送中]
        DR3[顧客宅配送]
        DR4[配送完了登録]
    end
    
    %% ========================================
    %% フロー定義
    %% ========================================
    
    C1 --> W1
    W1 --> C2
    C2 --> W2
    W2 --> C3
    C3 --> W3
    W3 --> C4
    C4 --> W4
    W4 --> W5
    W5 --> O1
    
    O1 --> O2
    O2 --> I1
    I1 --> I2
    I2 -->|Yes| I3
    I3 --> I4
    I4 --> O3
    
    O3 --> P1
    P1 --> P2
    P2 --> P3
    P3 -->|Yes| P4
    P4 --> P5
    P5 --> O4
    
    O4 --> O5
    O5 --> N1
    N1 --> N2
    N2 --> N3
    N3 --> C5
    
    O5 --> O6
    O6 --> D1
    D1 --> D2
    D2 --> D3
    D3 --> O7
    O7 --> W7
    W7 --> C5
    
    D3 --> D4
    D4 --> WH1
    WH1 --> WH2
    WH2 --> WH3
    WH3 --> WH4
    WH4 --> WH5
    
    WH5 --> D5
    D5 --> N4
    N4 --> C6
    
    D5 --> DR1
    DR1 --> DR2
    DR2 --> DR3
    DR3 --> C7
    
    DR3 --> DR4
    DR4 --> N3
    N3 --> C8
    
    %% ========================================
    %% スタイル定義
    %% ========================================
    
    style C1 fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    style C2 fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    style C3 fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    style C4 fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    style C5 fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    style C6 fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    style C7 fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    style C8 fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    
    style W1 fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    style W2 fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    style W3 fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    style W4 fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    style W5 fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    style W7 fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    
    style O1 fill:#E8F5E9,stroke:#388E3C,stroke-width:2px
    style O2 fill:#E8F5E9,stroke:#388E3C,stroke-width:2px
    style O3 fill:#E8F5E9,stroke:#388E3C,stroke-width:2px
    style O4 fill:#E8F5E9,stroke:#388E3C,stroke-width:2px
    style O5 fill:#E8F5E9,stroke:#388E3C,stroke-width:2px
    style O6 fill:#E8F5E9,stroke:#388E3C,stroke-width:2px
    style O7 fill:#E8F5E9,stroke:#388E3C,stroke-width:2px
    
    style I1 fill:#FFF3E0,stroke:#F57C00,stroke-width:2px
    style I2 fill:#FFFF99,stroke:#FFD700,stroke-width:2px
    style I3 fill:#FFF3E0,stroke:#F57C00,stroke-width:2px
    style I4 fill:#FFF3E0,stroke:#F57C00,stroke-width:2px
    
    style P1 fill:#FCE4EC,stroke:#C2185B,stroke-width:2px
    style P2 fill:#FCE4EC,stroke:#C2185B,stroke-width:2px
    style P3 fill:#FFFF99,stroke:#FFD700,stroke-width:2px
    style P4 fill:#FCE4EC,stroke:#C2185B,stroke-width:2px
    style P5 fill:#FCE4EC,stroke:#C2185B,stroke-width:2px
    
    style WH1 fill:#FFF9C4,stroke:#F57F17,stroke-width:2px
    style WH2 fill:#FFF9C4,stroke:#F57F17,stroke-width:2px
    style WH3 fill:#FFF9C4,stroke:#F57F17,stroke-width:2px
    style WH4 fill:#FFF9C4,stroke:#F57F17,stroke-width:2px
    style WH5 fill:#FFF9C4,stroke:#F57F17,stroke-width:2px
```

---

## スイムレーン図：詳細版（データと物の流れを明示）

```mermaid
graph TB
    subgraph "🙎 顧客"
        direction TB
        C_Browse[📱 商品閲覧]
        C_Cart[🛒 カートに追加]
        C_Input[📝 配送先入力]
        C_Confirm[✅ 注文確定]
        C_Email1[📧 確認メール受信]
        C_Email2[📧 発送通知受信]
        C_Receive[📦 商品受取]
    end
    
    subgraph "💻 Webアプリケーション"
        direction TB
        W_Display[🖼️ 商品表示]
        W_UpdateCart[🔄 カート更新]
        W_Form[📋 入力フォーム]
        W_Validate[✔️ 入力検証]
        W_API[🔌 API呼出]
        W_Complete[🎉 完了画面]
    end
    
    subgraph "⚙️ 注文サービス"
        direction TB
        O_Receive[📥 注文受信]
        O_CheckInv[📦 在庫確認]
        O_Payment[💳 決済処理]
        O_Save[💾 注文保存]
        O_Event[📨 イベント発行]
        O_Delivery[🚚 配送手配]
    end
    
    subgraph "📊 データベース"
        direction TB
        DB_Order[(注文DB)]
        DB_Product[(商品DB)]
        DB_Customer[(顧客DB)]
    end
    
    subgraph "📦 在庫システム"
        direction TB
        INV_Check[🔍 在庫照会]
        INV_Reserve[🔒 在庫引当]
        INV_Update[🔄 在庫更新]
    end
    
    subgraph "💳 決済GW"
        direction TB
        PAY_Auth[🔐 認証]
        PAY_Process[💰 決済実行]
        PAY_Result[✅結果返却]
    end
    
    subgraph "📧 通知サービス"
        direction TB
        NOTIF_Queue[📮 キュー受信]
        NOTIF_Template[📄 テンプレート]
        NOTIF_Send[📤 メール送信]
    end
    
    subgraph "🚚 配送業者"
        direction TB
        DEL_Request[📋 依頼受信]
        DEL_Number[🔢 番号発行]
        DEL_Warehouse[🏭 倉庫指示]
        DEL_Track[📍 追跡更新]
    end
    
    subgraph "🏭 倉庫"
        direction TB
        WH_List[📋 リスト受信]
        WH_Pick[📦 ピッキング]
        WH_Pack[📦 梱包]
        WH_Ship[🚚 出荷]
    end
    
    subgraph "🚛 配送"
        direction TB
        DRV_Pickup[📦 集荷]
        DRV_Transit[🚚 配送中]
        DRV_Deliver[🏠 配達]
    end
    
    %% ========================================
    %% データフロー
    %% ========================================
    
    C_Browse -->|商品ID| W_Display
    W_Display -->|商品情報| DB_Product
    
    C_Cart -->|商品追加| W_UpdateCart
    W_UpdateCart -->|セッション保存| DB_Customer
    
    C_Input -->|配送先データ| W_Form
    W_Form --> W_Validate
    
    C_Confirm -->|注文データ| W_API
    W_API -->|注文情報| O_Receive
    
    O_Receive -->|在庫確認要求| O_CheckInv
    O_CheckInv -->|在庫照会| INV_Check
    INV_Check -->|在庫情報| INV_Reserve
    INV_Reserve -->|引当完了| O_Payment
    
    O_Payment -->|決済要求| PAY_Auth
    PAY_Auth --> PAY_Process
    PAY_Process --> PAY_Result
    PAY_Result -->|決済結果| O_Save
    
    O_Save -->|注文レコード| DB_Order
    O_Save --> O_Event
    
    O_Event -->|OrderConfirmedEvent| NOTIF_Queue
    NOTIF_Queue --> NOTIF_Template
    NOTIF_Template --> NOTIF_Send
    NOTIF_Send -->|確認メール| C_Email1
    
    O_Event -->|配送依頼| O_Delivery
    O_Delivery -->|配送要求| DEL_Request
    DEL_Request --> DEL_Number
    DEL_Number -->|配送番号| DB_Order
    DEL_Number --> W_Complete
    W_Complete --> C_Email1
    
    %% ========================================
    %% 物の流れ
    %% ========================================
    
    DEL_Number -.->|出荷指示データ| DEL_Warehouse
    DEL_Warehouse -.->|ピッキングリスト| WH_List
    
    WH_List -.->|作業指示| WH_Pick
    WH_Pick -.->|商品| WH_Pack
    WH_Pack -.->|梱包済商品| WH_Ship
    
    WH_Ship -.->|出荷完了通知| DEL_Track
    DEL_Track --> NOTIF_Queue
    NOTIF_Send -->|発送通知| C_Email2
    
    WH_Ship -.->|荷物| DRV_Pickup
    DRV_Pickup -.->|輸送| DRV_Transit
    DRV_Transit -.->|配達| DRV_Deliver
    DRV_Deliver -.->|商品| C_Receive
    
    DRV_Deliver -.->|配送完了通知| DEL_Track
    
    %% ========================================
    %% スタイル
    %% ========================================
    
    style DB_Order fill:#4CAF50,stroke:#2E7D32,color:#fff
    style DB_Product fill:#4CAF50,stroke:#2E7D32,color:#fff
    style DB_Customer fill:#4CAF50,stroke:#2E7D32,color:#fff
```

---

## 時系列スイムレーン図（シーケンス形式）

```mermaid
sequenceDiagram
    participant C as 👤 顧客
    participant W as 💻 Webアプリ
    participant O as ⚙️ 注文サービス
    participant I as 📦 在庫システム
    participant P as 💳 決済GW
    participant DB as 💾 DB
    participant N as 📧 通知サービス
    participant D as 🚚 配送業者
    participant WH as 🏭 倉庫
    participant DR as 🚛 ドライバー
    
    Note over C,DR: 注文フェーズ
    C->>W: ①商品閲覧・カートに追加
    W->>DB: セッション保存
    C->>W: ②配送先・支払情報入力
    C->>W: ③注文確定ボタン押下
    W->>W: 入力検証
    W->>O: ④注文API呼出
    
    Note over O,I: 在庫確認フェーズ
    O->>I: ⑤在庫確認要求
    I->>I: 在庫照会
    I-->>O: 在庫あり
    I->>I: 在庫引当
    
    Note over O,P: 決済フェーズ
    O->>P: ⑥決済要求
    P->>P: カード認証
    P->>P: 決済実行
    P-->>O: ⑦決済成功
    
    Note over O,N: 注文確定フェーズ
    O->>DB: ⑧注文保存
    O->>N: ⑨OrderConfirmedイベント発行
    N->>N: メールテンプレート生成
    N->>C: ⑩注文確認メール送信
    O-->>W: 注文番号返却
    W-->>C: 注文完了画面表示
    
    Note over O,WH: 配送手配フェーズ
    O->>D: ⑪配送依頼
    D->>D: 配送番号発行
    D-->>O: 配送番号返却
    O->>DB: 配送情報保存
    D->>WH: ⑫出荷指示送信
    
    Note over WH: 倉庫作業フェーズ
    WH->>WH: ⑬ピッキングリスト確認
    WH->>WH: 商品ピッキング
    WH->>WH: 検品・梱包
    WH->>D: ⑭出荷完了通知
    
    Note over D,C: 発送通知フェーズ
    D->>N: ShipmentStartedイベント
    N->>C: ⑮発送通知メール送信
    
    Note over WH,DR: 配送フェーズ
    WH->>DR: ⑯荷物引渡
    DR->>DR: 配送中
    DR->>C: ⑰商品配達
    
    Note over DR,C: 配送完了フェーズ
    DR->>D: ⑱配送完了登録
    D->>N: Deliveredイベント
    N->>C: ⑲配送完了メール送信
```

---

## 責任分担表（RACI Matrix）

### 注文処理プロセス

| タスク | 顧客 | Webアプリ | 注文サービス | 在庫システム | 決済GW | 通知サービス | 配送業者 | 倉庫 |
|-------|-----|----------|------------|------------|--------|------------|---------|-----|
| **商品閲覧** | R | A | - | I | - | - | - | - |
| **カートに追加** | R | A | - | - | - | - | - | - |
| **配送先入力** | R | A | - | - | - | - | - | - |
| **注文確定** | R | C | A | - | - | - | - | - |
| **在庫確認** | - | - | R | A | - | - | - | I |
| **決済処理** | I | - | R | - | A | - | - | - |
| **注文保存** | - | - | A | - | - | - | - | - |
| **確認メール送信** | I | - | R | - | - | A | - | - |
| **配送手配** | - | - | R | - | - | - | A | I |
| **商品ピッキング** | - | - | - | - | - | - | I | A |
| **梱包作業** | - | - | - | - | - | - | I | A |
| **配送** | I | - | - | - | - | - | R | - |
| **配送完了通知** | I | - | - | - | - | A | R | - |

**凡例:**
- **R (Responsible)**: 実行責任者
- **A (Accountable)**: 説明責任者（最終意思決定者）
- **C (Consulted)**: 相談先
- **I (Informed)**: 報告先

---

## エラーハンドリング スイムレーン

```mermaid
graph TB
    subgraph "顧客"
        C_Order[注文実行]
        C_Error[エラー画面表示]
        C_Retry[再試行]
    end
    
    subgraph "注文サービス"
        O_Process[注文処理]
        O_Detect{エラー検知}
        O_Log[エラーログ記録]
        O_Notify[エラー通知]
    end
    
    subgraph "在庫システム"
        I_Check[在庫確認]
        I_Error{在庫不足}
    end
    
    subgraph "決済GW"
        P_Process[決済処理]
        P_Error{決済失敗}
    end
    
    subgraph "補償トランザクション"
        COMP_Inventory[在庫引当取消]
        COMP_Payment[決済キャンセル]
        COMP_Order[注文キャンセル]
    end
    
    subgraph "通知サービス"
        N_ErrorEmail[エラー通知メール]
        N_AdminAlert[管理者アラート]
    end
    
    C_Order --> O_Process
    O_Process --> I_Check
    I_Check --> I_Error
    
    I_Error -->|在庫不足| O_Detect
    
    O_Process --> P_Process
    P_Process --> P_Error
    P_Error -->|失敗| O_Detect
    
    O_Detect --> O_Log
    O_Log --> O_Notify
    
    O_Notify --> COMP_Inventory
    COMP_Inventory --> COMP_Payment
    COMP_Payment --> COMP_Order
    
    O_Notify --> N_ErrorEmail
    O_Notify --> N_AdminAlert
    
    N_ErrorEmail --> C_Error
    C_Error --> C_Retry
    C_Retry --> O_Process
    
    style C_Error fill:#FFCDD2,stroke:#C62828,stroke-width:2px
    style O_Detect fill:#FFFF99,stroke:#FFD700,stroke-width:2px
    style I_Error fill:#FFFF99,stroke:#FFD700,stroke-width:2px
    style P_Error fill:#FFFF99,stroke:#FFD700,stroke-width:2px
    style COMP_Inventory fill:#FFE0B2,stroke:#E65100,stroke-width:2px
    style COMP_Payment fill:#FFE0B2,stroke:#E65100,stroke-width:2px
    style COMP_Order fill:#FFE0B2,stroke:#E65100,stroke-width:2px
```

---

## プロセスタイミング分析

### 各レーンの処理時間

| レーン | タスク | 最小時間 | 平均時間 | 最大時間 | 備考 |
|-------|-------|---------|---------|---------|------|
| **顧客** | 商品選択～注文確定 | 1分 | 5分 | 30分 | ユーザー操作 |
| **Webアプリ** | 入力検証～API呼出 | 0.1秒 | 0.5秒 | 2秒 | 同期処理 |
| **注文サービス** | 受付～確定 | 2秒 | 5秒 | 30秒 | 外部API含む |
| **在庫システム** | 在庫確認～引当 | 0.5秒 | 1秒 | 5秒 | DB処理 |
| **決済GW** | 認証～決済完了 | 2秒 | 3秒 | 10秒 | ネットワーク依存 |
| **通知サービス** | メール生成～送信 | 1秒 | 2秒 | 10秒 | 非同期処理 |
| **配送業者** | 番号発行～倉庫通知 | 5秒 | 10秒 | 30秒 | API処理 |
| **倉庫** | ピッキング～出荷 | 5分 | 15分 | 60分 | 人的作業 |
| **配送** | 集荷～配達完了 | 24時間 | 48時間 | 120時間 | 物理的配送 |

### クリティカルパス

```
顧客 → Webアプリ → 注文サービス → 在庫システム → 決済GW → DB保存 → 通知
```

**合計処理時間（注文確定まで）**: 約 **5-10秒**

---

## レーン間のインターフェース定義

### API / メッセージング

| 送信元レーン | 受信先レーン | インターフェース | プロトコル | データ形式 |
|------------|------------|----------------|----------|----------|
| Webアプリ | 注文サービス | POST /api/orders | REST API | JSON |
| 注文サービス | 在庫システム | POST /api/inventory/check | REST API | JSON |
| 注文サービス | 決済GW | POST /v1/payments | REST API | JSON |
| 注文サービス | 通知サービス | OrderConfirmedEvent | RabbitMQ | JSON |
| 注文サービス | 配送業者 | POST /api/shipments | REST API | XML/JSON |
| 配送業者 | 倉庫 | ShipmentRequestedEvent | SOAP/WebHook | XML |
| 通知サービス | 顧客 | メール送信 | SMTP | HTML |

---

## 並行処理の可視化

```mermaid
graph TB
    Start([注文確定])
    
    subgraph "並行処理グループ"
        direction LR
        Parallel1[在庫引当]
        Parallel2[顧客情報更新]
        Parallel3[ポイント計算]
    end
    
    subgraph "決済処理"
        Payment[決済実行]
    end
    
    subgraph "並行通知グループ"
        direction LR
        Notify1[確認メール送信]
        Notify2[SMS送信]
        Notify3[プッシュ通知]
    end
    
    End([完了])
    
    Start --> Parallel1
    Start --> Parallel2
    Start --> Parallel3
    
    Parallel1 --> Payment
    Parallel2 --> Payment
    Parallel3 --> Payment
    
    Payment --> Notify1
    Payment --> Notify2
    Payment --> Notify3
    
    Notify1 --> End
    Notify2 --> End
    Notify3 --> End
    
    style Start fill:#90ee90,stroke:#228b22,stroke-width:3px
    style End fill:#90ee90,stroke:#228b22,stroke-width:3px
```

---

## まとめ

### スイムレーン図の利点

✅ **責任の明確化**: 各タスクの担当者・システムが一目瞭然  
✅ **プロセスの可視化**: 業務フロー全体を俯瞰  
✅ **ボトルネック発見**: 処理時間の長いレーンを特定  
✅ **インターフェース設計**: レーン間の連携方法を明示  
✅ **コミュニケーション**: ステークホルダー間の共通理解  

### 活用シーン

- **業務分析**: 現状プロセスの問題点発見
- **要件定義**: システム化範囲とステークホルダーの整理
- **設計**: API・メッセージング設計の基礎
- **テスト**: 結合テストシナリオ作成
- **運用**: 障害時の影響範囲特定

### 改善ポイントの発見

| レーン | 現状の問題 | 改善案 |
|-------|-----------|-------|
| **在庫システム** | API応答が遅い（3-5秒） | キャッシュ導入で1秒以内に |
| **決済GW** | タイムアウトが頻発 | リトライ処理の実装 |
| **倉庫** | ピッキングに時間がかかる | バーコードスキャン導入 |
| **通知サービス** | メール送信が同期処理 | 非同期化してレスポンス改善 |
