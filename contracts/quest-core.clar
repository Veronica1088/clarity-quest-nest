;; Quest Status
(define-data-var quest-counter uint u0)
(define-constant contract-owner tx-sender)

(define-map quests
  { quest-id: uint }
  {
    creator: principal,
    title: (string-ascii 50),
    description: (string-ascii 200),
    required-proof: (string-ascii 50),
    reward: uint,
    status: (string-ascii 10)
  }
)

(define-public (create-quest (title (string-ascii 50)) (description (string-ascii 200)) (required-proof (string-ascii 50)) (reward uint))
  (begin
    (asserts! (>= reward u0) (err u400))
    (let
      ((quest-id (var-get quest-counter)))
      (map-set quests
        { quest-id: quest-id }
        {
          creator: tx-sender,
          title: title,
          description: description,
          required-proof: required-proof,
          reward: reward,
          status: "active"
        }
      )
      (var-set quest-counter (+ quest-id u1))
      (ok quest-id)
    )
  )
)

(define-public (complete-quest (quest-id uint) (proof (string-ascii 200)))
  (let ((quest (unwrap! (get-quest quest-id) (err u404))))
    (asserts! (is-eq (get status quest) "active") (err u403))
    (try! (contract-call? .profile update-experience tx-sender (get reward quest)))
    (try! (contract-call? .achievement mint-achievement quest-id tx-sender))
    (ok true)
  )
)

(define-read-only (get-quest (quest-id uint))
  (map-get? quests { quest-id: quest-id })
)

(define-read-only (get-quest-contract)
  contract-owner
)
