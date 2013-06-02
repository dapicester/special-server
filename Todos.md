# Password Reset
- add tests for concerns
  - use shared examples (see lint spec)
  - dry other tests
- better emails
  - layout
- refactoring
  - view partials

# Signup Confirmation
- similar to Password Reset
  - add a flag on db
  - send email on signup
  - email link update the flag
  - allow login
- send email setup

# Other
- mail
  - server
      admin@wewewho.it
      r23rxd23se1
      smtp.nomedominio.xxx:25 STARTTLS (cifratura: nessuna, autenticazione: Password Normale)
  - HTML mail
  - layout
- split locales
- test for locales
- fix `Guardfile`
  - reload on locale change
- routes test

# subito!
- Feed controller
- routes constraints + specs

# user roles
- add admin
- use seeds for creating the admin

# CSS
- thoroughly check the appearance

# javascript
- test
- use coffee whenever possible

# edit profile
- refactoring code and test
- set field old_password

# microposts
- add test for pagination
- check that delete link doesn't appear for other users' posts
- fix layout for long word (wrap)

# all
- refactoring the pages so that are similar with the homepage
- remove magic values
- use more JavaScript in order to avoid page reloads

# New Features (to be evaluated)
- Replies: posts beginning with "@user"
- Private Messaging: posts beginning with "d"
- Follower notification: send email notification (configurable on/off)
- RSS feed
- Password reminder, signup confirmation, remember me (from scratch or using Devise)
- Search users
