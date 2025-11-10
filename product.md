# 生産管理データモデル

## 1. 製品マスタ (Products Table)
| 項目名          | 日本語名        | 型         | キー     | 補足                                     |
|----------------|---------------|-----------|---------|----------------------------------------|
| ProductID      | 製品ID         | INT       | 主キー   | 一意の製品識別ID                          |
| ProductName    | 製品名         | VARCHAR   |         | 製品の名称                                |
| Category       | カテゴリ       | VARCHAR   |         | 製品カテゴリ（例: 部品、完成品）              |
| Specifications | 仕様           | TEXT      |         | 製品の詳細仕様（寸法、表面処理など）           |
| CostPrice      | 原価           | DECIMAL   |         | 単位あたりの原価                           |
| SellingPrice   | 販売価格       | DECIMAL   |         | 単位あたりの販売価格                        |
| CreatedDate    | 作成日         | DATETIME  |         | データ登録日時                             |

---

## 2. 材料マスタ (Materials Table)
| 項目名          | 日本語名        | 型         | キー     | 補足                                     |
|----------------|---------------|-----------|---------|----------------------------------------|
| MaterialID     | 材料ID         | INT       | 主キー   | 一意の材料識別ID                          |
| MaterialName   | 材料名         | VARCHAR   |         | 材料の名称                                |
| MaterialType   | 材質           | VARCHAR   |         | 材料種別（例: 鋼、アルミニウムなど）          |
| Dimensions     | 寸法           | VARCHAR   |         | 材料の規格（例: 厚さ、長さ、幅）              |
| StockQuantity  | 在庫数量       | INT       |         | 現在の在庫数                               |
| SafetyStock    | 安全在庫数     | INT       |         | 在庫不足を防ぐための最低在庫数                 |
| SupplierID     | サプライヤID    | INT       | 外部キー | サプライヤーテーブルへの参照                  |

---

## 3. 製造工程 (Production Processes Table)
| 項目名          | 日本語名        | 型         | キー     | 補足                                     |
|----------------|---------------|-----------|---------|----------------------------------------|
| ProcessID      | 工程ID         | INT       | 主キー   | 一意の工程識別ID                          |
| ProcessName    | 工程名         | VARCHAR   |         | 工程の名称（例: 切削、溶接、研磨など）         |
| SequenceNumber | 工程順序       | INT       |         | 工程の順序                               |
| LinkedProductID| 製品ID         | INT       | 外部キー | 対応する製品へのリンク                     |
| LeadTime       | 所要時間       | DECIMAL   |         | 工程に必要な時間（単位: 時間）                |
| Specifications | 加工仕様       | TEXT      |         | 工程ごとの加工仕様（例: 寸法公差、表面粗さ）     |

---

## 4. 在庫管理 (Inventory Table)
| 項目名           | 日本語名       | 型         | キー     | 補足                                      |
|-----------------|--------------|-----------|---------|-----------------------------------------|
| InventoryID     | 在庫ID        | INT       | 主キー    | 在庫管理ID                                 |
| ItemID          | アイテムID     | INT       | 外部キー  | 材料または製品の識別用ID                    |
| ItemType        | アイテム種別    | VARCHAR   |         | 材料または製品を区別（例: Material/Product） |
| Location        | 保管場所       | VARCHAR   |         | 倉庫や棚区分名                              |
| CurrentQuantity | 現在庫数       | INT       |         | 現在の在庫数量                              |
| ReorderPoint    | 再発注点       | INT       |         | 補充の必要がある在庫数                      |
| ReorderQuantity | 再発注数量     | INT       |         | 再発注時の発注推奨数量                      |

---

## 5. BOM（部品表: Bill of Materials）
| 項目名          | 日本語名        | 型         | キー     | 補足                                     |
|----------------|---------------|-----------|---------|----------------------------------------|
| BOMID          | BOMID         | INT       | 主キー   | BOM識別ID                                |
| ProductID      | 製品ID         | INT       | 外部キー | 製品マスタへの参照                        |
| MaterialID     | 材料ID         | INT       | 外部キー |