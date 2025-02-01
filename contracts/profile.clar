(define-map user-profiles
  { user: principal }
  {
    level: uint,
    experience: uint,
    completed-quests: uint
  }
)

(define-public (initialize-profile)
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

(define-read-only (get-profile (user principal))
  (map-get? user-profiles { user: user })
)
