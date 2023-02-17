A Heartbeat server, designed to recieve pulses from clients and send out alerts for any instances of client inactivity.

Server ENV variables:
```
DEFAULT_TO_ADDRESS          => email(s) to be alerted
DEFAULT_FROM_ADDRESS        => sender email
TASK_INACTIVE_AFTER_MINUTES => Time before task is considered inactive. Default: 30 minutes
```
