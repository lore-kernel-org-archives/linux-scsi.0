From: Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH] requesed -> requested
Date: Tue,  7 Aug 2018 01:14:29 -0400
Message-ID: <20180807051429.19077-1-mudongliangabcd@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: aacraid@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dzm77@ist.psu.edu, Dongliang Mu <mudongliangabcd@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/scsi/aacraid/commsup.c | 2 +-
 drivers/scsi/aacraid/dpcsup.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index d62ddd63f4fe..6e1b022a823d 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -514,7 +514,7 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 	 *	The only invalid cases are if the caller requests to wait and
 	 *	does not request a response and if the caller does not want a
 	 *	response and the Fib is not allocated from pool. If a response
-	 *	is not requesed the Fib will just be deallocaed by the DPC
+	 *	is not requested the Fib will just be deallocaed by the DPC
 	 *	routine when the response comes back from the adapter. No
 	 *	further processing will be done besides deleting the Fib. We
 	 *	will have a debug mode where the adapter can notify the host
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index 417ba349e10e..ddc69738375f 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -65,7 +65,7 @@ unsigned int aac_response_normal(struct aac_queue * q)
 	/*
 	 *	Keep pulling response QEs off the response queue and waking
 	 *	up the waiters until there are no more QEs. We then return
-	 *	back to the system. If no response was requesed we just
+	 *	back to the system. If no response was requested we just
 	 *	deallocate the Fib here and continue.
 	 */
 	while(aac_consumer_get(dev, q, &entry))
-- 
2.18.0
