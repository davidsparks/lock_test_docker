# Redis lock test
A complete docker-based Drupal 7 setup for testing Redis locks with parallel threads. See https://www.drupal.org/project/redis/issues/3093403.

The directory /web contains the Drupal 7 codebase with the [lock_test module](https://github.com/davidsparks/lock_test) and its dependencies installed.

## Installation

From the project base directory on the host machine
- docker-compose up -d
- scripts/setup.sh

Open a shell in the php container:
- docker exec -it drupal_php bash

In the php container:
- install.sh

## Run tests
Monitor watchdog output in the php container:
- drush @default.dev ws --tail 

#### 1. Using database for locks:
Open a second terminal on the host machine, and open another shell in the php container
- docker exec -it drupal_php bash

Run tests in the second shell:
- curl drupal.localhost/lock-test

#### 2. Using Redis for locks:
Switch to Redis lock and run the tests again
- echo "\$conf['lock_inc'] = 'sites/all/modules/redis/redis.lock.inc';" >> ${DRUPAL_ROOT}/sites/default/settings.php 
- curl drupal.localhost/lock-test

## Results
#### Test 1:
<pre>
64  09/Nov 12:15  debug     lock_test  Pass 001 Value 001 Acquired 3.6137 Released 3.6156  
65  09/Nov 12:15  debug     lock_test  Pass 002 Value 002 Acquired 3.6777 Released 3.6807  
66  09/Nov 12:15  debug     lock_test  Pass 004 Value 003 Acquired 3.7220 Released 3.7258  
67  09/Nov 12:15  debug     lock_test  Pass 003 Value 004 Acquired 3.7273 Released 3.7325  
68  09/Nov 12:15  debug     lock_test  Pass 005 Value 005 Acquired 3.7496 Released 3.7529  
69  09/Nov 12:15  debug     lock_test  Pass 006 Value 006 Acquired 3.8000 Released 3.8055  
70  09/Nov 12:15  debug     lock_test  Pass 008 Value 007 Acquired 3.8253 Released 3.8291  
71  09/Nov 12:15  debug     lock_test  Pass 007 Value 008 Acquired 3.8784 Released 3.8808 (1 wait)  
72  09/Nov 12:15  debug     lock_test  Pass 009 Value 009 Acquired 3.8818 Released 3.8853  
73  09/Nov 12:15  debug     lock_test  Pass 010 Value 010 Acquired 3.8872 Released 3.8951  
74  09/Nov 12:15  debug     lock_test  Pass 011 Value 011 Acquired 3.9494 Released 3.9524  
75  09/Nov 12:15  debug     lock_test  Pass 012 Value 012 Acquired 3.9524 Released 3.9552  
76  09/Nov 12:15  debug     lock_test  Pass 013 Value 013 Acquired 3.9585 Released 3.9621  
77  09/Nov 12:15  debug     lock_test  Pass 014 Value 014 Acquired 4.0225 Released 4.0252  
78  09/Nov 12:15  debug     lock_test  Pass 016 Value 015 Acquired 4.0260 Released 4.0299  
79  09/Nov 12:15  debug     lock_test  Pass 015 Value 016 Acquired 4.0510 Released 4.0566 (1 wait)     
80  09/Nov 12:15  debug     lock_test  Pass 017 Value 017 Acquired 4.0912 Released 4.0944  
81  09/Nov 12:15  debug     lock_test  Pass 018 Value 018 Acquired 4.1198 Released 4.1239 (1 wait)   
82  09/Nov 12:15  debug     lock_test  Pass 019 Value 019 Acquired 4.1489 Released 4.1551 (1 wait)  
83  09/Nov 12:15  debug     lock_test  Pass 020 Value 020 Acquired 4.1648 Released 4.1680  
84  09/Nov 12:15  debug     lock_test  Pass 021 Value 021 Acquired 4.1844 Released 4.1868  
85  09/Nov 12:15  debug     lock_test  Pass 022 Value 022 Acquired 4.2725 Released 4.2743  
86  09/Nov 12:15  debug     lock_test  Pass 023 Value 023 Acquired 4.2761 Released 4.2793  
87  09/Nov 12:15  debug     lock_test  Pass 024 Value 024 Acquired 4.3040 Released 4.3105 (1 wait)   
88  09/Nov 12:15  debug     lock_test  Pass 025 Value 025 Acquired 4.3194 Released 4.3213  
</pre>

'Acquired' and 'Released' show the current clock time in seconds.  
Each thread waits for the lock to be released before acquiring it, and the counter is incremented correctly.  

#### Test 2:

<pre>
 89  09/Nov 12:18  debug     lock_test  Pass 002 Value 001 Acquired 7.5132 Released 7.5178 <--  
 90  09/Nov 12:18  debug     lock_test  Pass 001 Value 001 Acquired 7.5132 Released 7.5185 <-- Acquired before release  
 91  09/Nov 12:18  debug     lock_test  Pass 004 Value 002 Acquired 7.5859 Released 7.5933  
 92  09/Nov 12:18  debug     lock_test  Pass 003 Value 003 Acquired 7.6166 Released 7.6205 (1 wait)   
 93  09/Nov 12:18  debug     lock_test  Pass 005 Value 004 Acquired 7.6371 Released 7.6429  
 94  09/Nov 12:18  debug     lock_test  Pass 006 Value 005 Acquired 7.6753 Released 7.6800  
 95  09/Nov 12:18  debug     lock_test  Pass 007 Value 006 Acquired 7.6876 Released 7.6935  
 96  09/Nov 12:18  debug     lock_test  Pass 008 Value 007 Acquired 7.7314 Released 7.7445  
 97  09/Nov 12:18  debug     lock_test  Pass 009 Value 008 Acquired 7.7478 Released 7.7558  
 98  09/Nov 12:18  debug     lock_test  Pass 010 Value 009 Acquired 7.7646 Released 7.7684  
 99  09/Nov 12:18  debug     lock_test  Pass 014 Value 010 Acquired 7.8259 Released 7.8343  
100  09/Nov 12:18  debug     lock_test  Pass 013 Value 011 Acquired 7.8425 Released 7.8493  
101  09/Nov 12:18  debug     lock_test  Pass 011 Value 012 Acquired 7.8567 Released 7.8619 (1 wait)   
102  09/Nov 12:18  debug     lock_test  Pass 012 Value 013 Acquired 7.8710 Released 7.8765  
103  09/Nov 12:18  debug     lock_test  Pass 015 Value 014 Acquired 7.9149 Released 7.9198 <--  
104  09/Nov 12:18  debug     lock_test  Pass 016 Value 014 Acquired 7.9147 Released 7.9218 <-- Acquired before release  
105  09/Nov 12:18  debug     lock_test  Pass 017 Value 015 Acquired 7.9487 Released 7.9557  
106  09/Nov 12:18  debug     lock_test  Pass 018 Value 016 Acquired 7.9570 Released 7.9616  
107  09/Nov 12:18  debug     lock_test  Pass 020 Value 017 Acquired 7.9952 Released 8.0033 <--  
108  09/Nov 12:18  debug     lock_test  Pass 019 Value 017 Acquired 7.9956 Released 8.0022 <-- Acquired before release  
109  09/Nov 12:18  debug     lock_test  Pass 022 Value 018 Acquired 8.0303 Released 8.0347  
110  09/Nov 12:18  debug     lock_test  Pass 021 Value 019 Acquired 8.0576 Released 8.0613 (1 wait)  
111  09/Nov 12:18  debug     lock_test  Pass 023 Value 020 Acquired 8.0732 Released 8.0800  
112  09/Nov 12:18  debug     lock_test  Pass 024 Value 021 Acquired 8.0819 Released 8.0861  
113  09/Nov 12:18  debug     lock_test  Pass 025 Value 022 Acquired 8.1012 Released 8.1037  
</pre>

In the rows marked "<--", the lock has been acquired by a thread before being released by the previous thread. The two threads have loaded the same value from cache, and both updated it to the same value. The counter is 'missing' three counts.  
