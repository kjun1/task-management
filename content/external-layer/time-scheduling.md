---
title: "時間・スケジューリング層"
type: docs
weight: 32
description: "時間制約、スケジューリング規則、期限管理の詳細仕様"
url: "/external-layer/time-scheduling/"
---

# 2. 時間・スケジューリング層

### 2.1 基本定義

**時間領域** $T$：

- 全順序集合（実時間の抽象）
- 離散時間または連続時間のモデル化が可能
- 時間粒度パラメータ $\tau_{\text{gran}} \in \{seconds, minutes, hours, days\}$

**外部イベント流** $\mathcal{E} \subseteq T \times \mathcal{U}$：

- $(t, u) \in \mathcal{E}$：時刻 $t$ での操作要求 $u$
- $\mathcal{U}$：要求タイプの集合（開始、停止、優先度変更など）

**スケジューラ** $\Sigma$：

$$\Sigma: \Gamma \to \mathcal{E}$$

- $\Gamma$：スケジューリング規則の集合
  - 期限（Deadline）
  - 時間窓（Time Window）
  - カレンダー制約
  - CRON式
  - トリガー条件

### 2.2 スケジューリング規則の数学的定式化

#### 2.2.1 期限制約の厳密定義

**期限制約**：

$$\text{deadline}(v, t_d, \text{severity}) \in \Gamma$$

- タスク $v$ は時刻 $t_d$ までに完了する必要がある
- $severity \in \{hard, soft, elastic\}$：制約の厳密性

**制約射影**：

$$\mathcal{C}_{\text{deadline}}(v, t_d, severity) = \begin{cases}
\text{forbid}(\text{add\_e}(*, v), t > t_d) & \text{if } severity = hard \\
\text{weight\_modifier}(\text{all\_ops}, w_{\text{penalty}}(t - t_d)) & \text{if } severity = soft \\
\text{precondition}(\text{all\_ops}, \text{negotiate\_deadline}(t_d)) & \text{if } severity = elastic
\end{cases}$$

#### 2.2.2 時間窓制約

**時間窓制約**：

$$\text{window}(v, [t_{\text{start}}, t_{\text{end}}], \text{recurrence}) \in \Gamma$$

- タスク $v$ は時間窓 $[t_{start}, t_{end}]$ 内でのみ実行可能
- $recurrence$：繰り返しパターン（daily, weekly, monthly, none）

**DAG性との関係**：

時間窓制約は内部DAGに対して以下の制約を追加します：

$$\forall u \prec v, \quad t_{\text{complete}}(u) \leq t_{\text{start}}(v)$$

これにより、時間的前後関係とDAGの順序関係の整合性を保証します。

#### 2.2.3 CRON式の形式定義

**CRON式** $C = (min, hour, day, month, dow)$：

$$C: T \to \{\top, \bot\}$$

where:

- $min \in [0,59] \cup \{*\}$：分
- $hour \in [0,23] \cup \{*\}$：時
- $day \in [1,31] \cup \{*\}$：日
- $month \in [1,12] \cup \{*\}$：月
- $dow \in [0,6] \cup \{*\}$：曜日

**評価関数**：

$$\text{CRON\_match}(C, t) = \bigwedge_{field \in C} \text{field\_match}(field, \text{extract}(field, t))$$

**周期的実行制約**：

$$\text{periodic}(\text{template}, C, \text{duration}) \in \Gamma$$

- テンプレートをCRON式に従って周期実行
- $duration$：各実行の最大継続時間

#### 2.2.4 カレンダー制約の詳細定義

**営業日カレンダー** $\mathcal{B} \subseteq T$：

$$\mathcal{B} = T \setminus (\text{Weekends} \cup \text{Holidays} \cup \text{CustomBlackouts})$$

**営業時間制約**：

$$\text{business\_hours}(\text{start\_time}, \text{end\_time}, \text{timezone}) \in \Gamma$$

**地域別カレンダー**：

$$\mathcal{B}_{\text{region}}: Region \times T \to \{⊤, ⊥\}$$

### 2.3 期限違反検出と自動再構成

#### 2.3.1 期限違反の数学的定義

期限違反は以下の述語で検出されます：

$$\text{late}(v,t) \iff \big(t > \text{deadline}(v) \wedge \neg\text{Done}(v,C)\big)$$

**早期警告システム**：

$$\text{approaching\_deadline}(v, t, \epsilon) \iff \big(t > \text{deadline}(v) - \epsilon \wedge \neg\text{Done}(v,C)\big)$$

#### 2.3.2 期限違反時の自動再構成メカニズム

期限違反検出時、以下の再構成戦略が $\eta$ を通じて適用されます：

**1. タスク分割戦略**：

$$\Delta_{\text{split}} = \{split\_v(v \Rightarrow v_{\text{critical}} \to v_{\text{defer}}, \phi_{\text{split}})\}$$

- 緊急部分 $v_{\text{critical}}$ と延期可能部分 $v_{\text{defer}}$ に分割
- 分割関数 $\phi_{\text{split}}$ は期限内完了可能性を最大化

**2. 並列化戦略**：

$$\Delta_{\text{parallel}} = \{fork\text{-}join(v \Rightarrow \{v_1, v_2, \ldots, v_n\}, \psi_{\text{parallel}})\}$$

- 独立実行可能な部分への分解

**3. 依存関係緩和戦略**：

$$\Delta_{\text{relax}} = \{del\_e(u, v), update\_\pi(u, w, \pi')\}$$

- 非必須依存関係の削除
- 射影の簡素化

**4. 資源追加戦略**：

外部制約を通じて資源増強を要求：

$$\mathcal{C}_{\text{resource\_boost}} = \text{require}(\text{all\_ops}, \text{allocate\_resource}(v, \text{additional\_capacity}))$$

### 2.4 時間制約の階層化

時間制約は以下の優先順序で適用されます：

1. **Hard constraints**：違反時は操作を完全に禁止
2. **Soft constraints**：違反時はペナルティを課すが実行可能
3. **Preference constraints**：可能な限り遵守するが必須ではない

**制約競合解決**：

複数の時間制約が競合する場合、以下のアルゴリズムで解決：

$$\text{resolve\_conflicts}(\text{constraints}) = \underset{\text{valid\_schedule}}{\arg\max} \sum \text{priority}(c) \times \text{satisfaction}(c, \text{schedule})$$

### 2.5 実時間と論理時間の分離

**論理時間** $s \in \mathbb{N}$（内部系）と**実時間** $t \in T$（外部層）の分離を維持：

- 内部系は論理ステップ $s$ のみを認識
- 外部層が実時間 $t$ を論理ステップに写像
- 写像 $\tau: T \to \mathbb{N}$ は単調増加関数

**時間同期メカニズム**：

$$\text{sync}(t) = \begin{cases}
s + 1 & \text{if trigger\_condition}(t) \\
s & \text{otherwise}
\end{cases}$$

---

**関連セクション**：

- [前: 概要と基本構造](/external-layer/)
- [次: 反復・繰り返し層](/external-layer/iteration/)