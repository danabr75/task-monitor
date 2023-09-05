A Heartbeat server, designed to recieve pulses from clients and send out alerts for any instances of client inactivity.

# Server ENV variables:
```
DEFAULT_TO_ADDRESS          => email(s) to be alerted
DEFAULT_FROM_ADDRESS        => sender email
TASK_INACTIVE_AFTER_MINUTES => Time before task is considered inactive. Default: 30 minutes
NO_CLOCK_AND_WORKERS        => If not running redis/sidekiq server and clock server, set env to 'true' to still allow operations. Missing pulses will be checked for during a recieving pulse event.
```
 
# Server: External API routes
- POST: /heartbeat
  - PARAMS/PAYLOAD:
    - token: <client_token>
- POST: /failure
  - PARAMS/PAYLOAD:
    - token: <client_token>


When clients do not check-in, on the `/heartbeat` route,  within the `TASK_INACTIVE_AFTER_MINUTES` deadline, an email will be sent out to `DEFAULT_TO_ADDRESS` with an alert.


# Server Implementation - Create new client in the database:
`client_token = Task.create_new_task!('ClientName') #=> Returns Token String`
- Use `client_token` when client is checking in via the `heartbeat` and `failure` server routes, using the `token` parameter


# Client Implementation:
- From the client, post `/heartbeat` to check-in with the server that everything is alright with the client
- From the client, post `/failure`  to check-in with the server that something has gone horribly wrong, and to immediately alert the `DEFAULT_TO_ADDRESS` addresses.

