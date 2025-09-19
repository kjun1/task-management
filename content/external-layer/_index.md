---
title: "概要と基本構造"
type: docs
weight: 31
description: "外部層の概要、設計原則、内部系との関係"
url: "/external-layer/"
---

# タスク管理フレームワーク：外部層仕様書

## 概要

本仕様書は、タスク管理の数学的フレームワークにおける **外部層（External Layer）** の設計を定義します。外部層は、内部の数学的構造（DAGベースのタスクネットワーク）を保持しながら、現実世界の制約（時間、資源、統治、経済性など）を統合するためのインターフェース層です。

### 基本設計原則

1. **分離の原則**：時間・繰り返し・資源制約は外部層で処理し、内部系の数学的純粋性を保持
2. **インターフェース最小化**：外部と内部の接続点を明確に限定
3. **拡張性**：新しい外部制約を既存構造を壊さずに追加可能
4. **一貫性保証**：外部層の操作が内部の不変条件（DAG性、型整合性など）を侵さない

---

## 1. 外部層の基本構造

### 1.1 内部系との関係

**内部系**（v1.1）は以下を提供：

- タスクネットワーク $\mathcal{T}_s = (V_s, E_s, F_s, \Pi_s)$
- 原始操作の生成系 $\Phi = \{\text{add\_v}, \text{del\_v}, \text{add\_e}, \text{del\_e}, \text{update\_}\pi, \text{update\_f}, \text{split\_v}, \text{merge}, \text{interpose}, \text{substitute}\}$
- 関係タイプ $\rho \in \{\text{upstream}, \text{downstream}, \text{interpose}, \text{replace}, \text{parallel}, \text{fork-join}\}$
- 再構成演算子 $\mathbf{R}: (\mathcal{T}_s, \Delta_s) \mapsto \mathcal{T}_{s+1}$（最小変更での最適化）
- 妥当性条件（DAG性・型整合・直和整合・射影整合）

**外部層**は以下を担当：

- 時間管理とスケジューリング（$\Sigma, \mathcal{R}$）
- 反復・繰り返し処理（$\iota, \Xi, \Lambda$）
- 資源制約と割り当て（$\kappa, \mathsf{I}$）
- 統治・コンプライアンス（$\mathsf{G}, \mathsf{Dg}, \mathsf{H}$）
- 経済性・優先度管理（$\mathsf{E}, \mathsf{P}$）
- 信頼性・障害処理（$\mathsf{Rx}, \mathsf{Dep}$）
- 監査・可観測性（$\mathsf{Lg}$）
- 学習・適応（$\mathsf{F}, \mathsf{ML}, \mathsf{Cfg}, \mathsf{Loc}$）

### 1.1.1 原始操作への制約射影

外部層の各構成要素は、内部系の原始操作に対して制約を射影します：

$$\mathcal{C}_{\text{ext}}: \text{ExternalConstraints} \to \text{Constraints on } \Phi$$

具体的には：

- **操作制限制約**：$\text{forbid}(\phi, \text{condition}) \in \mathcal{C}_{\text{ext}}$
- **実行順序制約**：$\text{order}(\phi_1 \prec \phi_2) \in \mathcal{C}_{\text{ext}}$
- **前提条件制約**：$\text{require}(\phi, \text{precondition}) \in \mathcal{C}_{\text{ext}}$

### 1.2 接続インターフェース

外部層と内部系は以下の**厳密に定義された写像**のみで接続されます：

| 写像 | 型 | 説明 | 原始操作への影響 |
|------|------|------|----------|
| $\eta$ | $(\mathcal{E}, \Omega_s, \Theta_s) \mapsto \Delta_s$ | 外部イベントと観測から内部差分を合成 | $\mathbf{R}(\mathcal{T}_s, \Delta_s)$ にて操作選択 |
| $\iota$ | $(\hat{\mathcal{T}}, t_k) \mapsto \mathcal{T}^{(k)}_0$ | テンプレートから反復インスタンスを生成 | 構造操作（split, substitute）を活用 |
| $\Xi$ | $O^{(k)} \to S^{(k)}$ | 反復完了時の状態を外部ストアに搬出 | 内部系の状態読み取り専用 |
| $\Lambda$ | $S^{(k)} \to I^{(k+1)}_{\text{init}}$ | 外部状態を次反復の初期入力に搬入 | update_f, add_v を通じた初期化 |
| $\mathcal{C}_{\text{ext}}$ | 外部制約 $\to$ 内部制約 | 外部制約を内部制約に射影 | $\Phi$ への制約として作用 |

#### 1.2.1 制約射影の厳密定義

制約射影 $\mathcal{C}_{\text{ext}}$ は以下の形式を持ちます：

$$\mathcal{C}_{\text{ext}}: \bigcup_{\text{layer}} \text{LayerConstraints} \to \text{OperationConstraints}(\Phi)$$

ここで $\text{OperationConstraints}(\Phi)$ は：

$$\text{OperationConstraints}(\Phi) = \begin{pmatrix}
\text{prohibition}: \Phi \times \text{Context} \to \{\top, \bot\} \\
\text{ordering}: \Phi \times \Phi \times \text{Context} \to \{\top, \bot\} \\
\text{precondition}: \Phi \times \text{Context} \to \text{Predicate} \\
\text{weight\_modifier}: \Phi \times \text{Context} \to \mathbb{R}_+
\end{pmatrix}$$

**関係タイプ $\rho$ との整合**：

外部制約は関係タイプ $\rho(\Delta_s)$ の判定にも影響し、許容操作選択 $\sigma(\rho)$ を通じて間接的に $\mathbf{R}$ の動作を制御します：

$$\mathcal{C}_{\text{ext}} \circ \sigma(\rho(\Delta_s)) \subseteq \Phi_{\text{allowed}}$$

---

## 外部層の階層構造

外部層は以下の各層に分割されています：

1. [時間・スケジューリング層](/external-layer/time-scheduling/) - 時間制約とスケジューリング規則
2. [反復・繰り返し層](/external-layer/iteration/) - 反復パターンと状態管理  
3. [資源・容量管理層](/external-layer/resource-management/) - リソース制約と割り当て
4. [統治・コンプライアンス層](/external-layer/governance/) - ガバナンスとコンプライアンス
5. [経済・優先度管理層](/external-layer/economic-priority/) - 経済性と優先度
6. [信頼性・障害処理層](/external-layer/reliability/) - 障害処理と回復
7. [監査・可観測性層](/external-layer/audit/) - 監査とモニタリング
8. [知性・学習層](/external-layer/intelligence/) - 機械学習と適応
9. [環境・ローカライゼーション層](/external-layer/environment/) - 環境適応とローカライゼーション
10. [統合・実装ガイドライン](/external-layer/integration/) - 層の統合と実装考慮事項

各層は独立して設計されており、必要に応じて組み合わせて使用できます。