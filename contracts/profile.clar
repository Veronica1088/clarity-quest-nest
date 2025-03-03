(define-map user-profiles
  { user: principal }
  {
    level: uint,
    experience: uint,
    completed-quests: uint
  }
)

(define-constant exp-per-level u100)

(define-public (initialize-profile)
  (begin
    (asserts! (is-none (get-profile tx-sender)) (err u403))
    (map-set user-profiles
      { user: tx-sender }
      {
        level: u1,
        experience: u0,
        completed-quests: u0
      }
    )
    (ok true)
  )
)

(define-public (update-experience (user principal) (exp-gain uint))
  (begin
    (asserts! (is-eq tx-sender (contract-call? .quest-core get-quest-contract)) (err u403))
    (let ((current-profile (unwrap! (get-profile user) (err u404))))
      (let ((new-exp (+ (get experience current-profile) exp-gain)))
        (map-set user-profiles
          { user: user }
          {
            level: (+ (get level current-profile) (/ new-exp exp-per-level)),
            experience: (mod new-exp exp-per-level),
            completed-quests: (+ (get completed-quests current-profile) u1)
          }
        )
        (ok true)
      )
    )
  )
)

(define-read-only (get-profile (user principal))
  (map-get? user-profiles { user: user })
)
