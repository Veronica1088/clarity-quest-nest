;; Quest Status
(define-data-var quest-counter uint u0)

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

(define-read-only (get-quest (quest-id uint))
  (map-get? quests { quest-id: quest-id })
)
