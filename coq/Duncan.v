(* This file formalizes the proofs from Duncan Coutts' thesis:

   "Stream Fusion: Practical shortcut fusion for coinductive sequence types".

   http://community.haskell.org/~duncan/thesis.pdf
*)

Require Export Coq.Unicode.Utf8.
Require Import Coq.Init.Datatypes.
Require Import Coq.Program.Tactics.
Require Import FunctionalExtensionality.
Require Import Hask.Prelude.
Require Import Hask.Control.Lens.
Require Import Hask.Control.Monad.
Require Import Hask.Control.Monad.Trans.Free.
Require Import Hask.Data.Functor.Identity.

(* Set Universe Polymorphism. *)

Generalizable All Variables.

Require Import Endo.
Require Import Iso.

Close Scope nat_scope.

(* Section 2.2.3 *)

Definition NatF (a : Type) := unit + a.

(* This does not work in Coq, because of the strict positivity requirement. *)
(* Inductive Fix (F : Type -> Type) := outF : F (Fix F) -> Fix F. *)

(* This definition works fine, however, and is equivalent. *)
Definition μ (F : Type -> Type) := ∀ a, (F a → a) → a.

Definition μNat := μ NatF.

Definition zero : μNat := λ a (X : NatF a   → a), X (inl tt).
Definition one  : μNat := λ a (X : unit + a → a), X (inr (X (inl tt))).

Definition ChurchNat := ∀ a, a → (a → a) → a.

Inductive Nat :=
  | Z : Nat
  | S : Nat -> Nat.

(*
Program Instance nat_is_muNat : Nat ≅ μNat.
Obligation 1.
  compute in *. intros.
  induction H; apply X.
    left. constructor.
  right. apply IHNat.
Defined.
Obligation 2.
  compute in *. intros.
  apply X. intros.
  destruct H.
    apply Z.
  apply (S n).
Defined.
Obligation 3.
  unfold nat_is_muNat_obligation_1.
  unfold nat_is_muNat_obligation_2.
  unfold compose.
  extensionality x.
  induction x; auto.
  simpl. rewrite IHx.
  reflexivity.
Defined.
Obligation 4.
  unfold nat_is_muNat_obligation_1.
  unfold nat_is_muNat_obligation_2.
  unfold compose.
  extensionality x.
  extensionality a.
  extensionality X.
  unfold id.
  compute in x.
  compute.
Abort.
*)

Program Instance nat_is_Church : μNat ≅ ChurchNat.
Obligation 1.
  compute in *. intros.
  apply X. intros.
  induction X2 as [| H].
    apply X0.                   (* Z case *)
  apply X1. apply H.            (* S case *)
Defined.
Obligation 2.
  compute in *. intros.
  apply X; intros; apply X0.
    left. constructor.          (* Z case *)
  right. apply X1.              (* S case *)
Defined.
Obligation 3.
  compute.
  extensionality H.
  extensionality a.
  extensionality X0.
  f_equal.
  extensionality X2.
  destruct X2.
    destruct u. reflexivity.
  reflexivity.
Qed.

Program Instance sum_distributive : ∀ a b c, ((a + b) → c) ≅ ((a → c) * (b → c)).
Solve All Obligations using auto.
Obligation 2. destruct X0; auto. Defined.
Obligation 3.
  compute.
  extensionality x.
  extensionality n.
  destruct n; auto.
Qed.
Obligation 4.
  compute.
  extensionality x.
  destruct x. auto.
Qed.

Program Instance unit_impl : ∀ a, (unit → a) ≅ a.
Solve All Obligations using auto.
Obligation 1. apply X. constructor. Defined.
Obligation 3.
  compute.
  extensionality H.
  extensionality tt.
  destruct tt. reflexivity.
Qed.

Section F.
  Variable F : Type → Type.
  Context `{Functor F}.

(* Definition 2.2.1 *)
Definition fold : ∀ a, (F a → a) → μ F → a :=
  fun a => fun k => fun x => x a k.

(* Definition 2.2.2 *)
Definition build : (∀ a, (F a → a) → a) → μ F :=
  fun g => fun b => fun k => g b k.

Inductive nu : Type := unNu : ∀ a, a → (a → F a) → nu.

(* Definition 2.2.3 *)
Definition unfold : ∀ a, (a → F a) → a → nu :=
  fun a => fun k => fun s => unNu a s k.

(* Definition 2.2.4 *)
Definition unbuild : ∀ c, (∀ a, (a → F a) → a → c) → (nu → c) :=
  fun c => fun g => fun x => match x with
    unNu _ s k => g _ k s
  end.

(* Theorem 3.2.1 *)
Theorem fold_build_fusion : ∀ a k g, fold a k (build g) = g a k.
Proof. auto. Qed.

(* Theorem 3.2.2 *)
Theorem unbuild_unfold_fusion : ∀ c a k g s, unbuild c g (unfold a k s) = g a k s.
Proof. auto. Qed.

Lemma free_theorem_for_fold : ∀ A A' h k k',
  h ∘ k = k' ∘ fmap h → h ∘ fold A k = fold A' k'.
Proof.
  intros.
  unfold fold, compose.
  extensionality x.
  (* jww (2014-09-08): How to proceed from here? *)
Admitted.

Definition initial_algebra (y : F (μ F)) : μ F :=
  fun b (k : F b -> b) => k (fmap (fold b k) y).

(* Lemma 3.3.2 *)
Theorem ump_fold_1 : ∀ a (h : μ F → a) (k : F a → a),
  h = fold a k → h ∘ initial_algebra = k ∘ fmap h.
Proof.
  intros.
  rewrite H0.
  extensionality y.
  unfold compose, fold, initial_algebra.
  auto.
Qed.

(* Lemma 3.3.3 *)
Theorem ump_fold_2 : ∀ a (h : μ F → a) (k : F a → a),
  h ∘ initial_algebra = k ∘ fmap h → h = fold a k.
Proof.
  intros.
  pose (free_theorem_for_fold (μ F) a h initial_algebra k).
  pose proof H0.
  apply e in H0. clear e.
  rewrite <- H0.
  replace (fold (μ F) initial_algebra) with (@id (μ F)).
    rewrite comp_id_right. reflexivity.
  symmetry.
  replace h with (fold a k) in H0.
  unfold compose in H0.
  unfold fold at 1 in H0.
  unfold fold at 2 in H0.
  rewrite (eta_expansion (fold (μ F) initial_algebra)).
Admitted.
