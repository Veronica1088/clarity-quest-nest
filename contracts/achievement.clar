(define-non-fungible-token achievement uint)
(define-fungible-token quest-token)

(define-data-var achievement-counter uint u0)

(define-map achievement-details
  { achievement-id: uint }
  {
    owner: principal,
    quest-id: uint,
    timestamp: uint
  }
)

;; Only allow minting through quest contract
(define-constant contract-owner tx-sender)

(define-public (mint-achievement (quest-id uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender (contract-call? .quest-core get-quest-contract)) (err u403))
    (let
      ((achievement-id (var-get achievement-counter)))
      (try! (nft-mint? achievement achievement-id recipient))
      (map-set achievement-details
        { achievement-id: achievement-id }
        {
          owner: recipient,
          quest-id: quest-id,
          timestamp: block-height
        }
      )
      (var-set achievement-counter (+ achievement-id u1))
      (ok achievement-id)
    )
  )
)
