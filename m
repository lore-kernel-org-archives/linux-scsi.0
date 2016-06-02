From: Wei Fang <fangwei1@huawei.com>
Subject: [PATCH v3 2/2] Documentation/scsi: update scsi_eh.txt about ->host_failed
Date: Thu, 2 Jun 2016 16:42:38 +0800
Message-ID: <1464856958-30647-2-git-send-email-fangwei1@huawei.com>
References: <1464856958-30647-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1464856958-30647-1-git-send-email-fangwei1@huawei.com>
Sender: stable-owner@vger.kernel.org
To: tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, corbet@lwn.net
Cc: hch@infradead.org, dan.j.williams@intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, stable@vger.kernel.org, Wei Fang <fangwei1@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Update the new rules of ->host_failed.

Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
 Documentation/scsi/scsi_eh.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
index 8638f61..9702c78 100644
--- a/Documentation/scsi/scsi_eh.txt
+++ b/Documentation/scsi/scsi_eh.txt
@@ -263,7 +263,6 @@ scmd->allowed.
 
  3. scmd recovered
     ACTION: scsi_eh_finish_cmd() is invoked to EH-finish scmd
-	- shost->host_failed--
 	- clear scmd->eh_eflags
 	- scsi_setup_cmd_retry()
 	- move from local eh_work_q to local eh_done_q
@@ -276,6 +275,7 @@ scmd->allowed.
 	- if retry is necessary, scmd is requeued using
           scsi_queue_insert()
 	- otherwise, scsi_finish_command() is invoked for scmd
+	- zero shost->host_failed
     LOCKING: queue or finish function performs appropriate locking
 
 
-- 
1.7.1
