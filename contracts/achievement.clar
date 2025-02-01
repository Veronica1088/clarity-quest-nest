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

(define-public (mint-achievement (quest-id uint))
  (let
    ((achievement-id (var-get achievement-counter)))
    (try! (nft-mint? achievement achievement-id tx-sender))
    (map-set achievement-details
      { achievement-id: achievement-id }
      {
        owner: tx-sender,
        quest-id: quest-id,
        timestamp: block-height
      }
    )
    (var-set achievement-counter (+ achievement-id u1))
    (ok achievement-id)
  )
)
