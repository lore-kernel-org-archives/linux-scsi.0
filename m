From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH 2/9] scsi: fix trivial typos
Date: Sun, 18 Oct 2015 23:31:08 +0800
Message-ID: <557286dd38beb4d8d1be28e787ad89611e7cc077.1445181079.git.geliangtang@163.com>
References: <949f6f3c99f87b57666986dc9f2d1c916935e215.1445181079.git.geliangtang@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <949f6f3c99f87b57666986dc9f2d1c916935e215.1445181079.git.geliangtang@163.com>
In-Reply-To: <949f6f3c99f87b57666986dc9f2d1c916935e215.1445181079.git.geliangtang@163.com>
References: <949f6f3c99f87b57666986dc9f2d1c916935e215.1445181079.git.geliangtang@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Jiri Kosina <trivial@kernel.org>
Cc: Geliang Tang <geliangtang@163.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

s/regsiter/register/

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/scsi/isci/registers.h       | 4 ++--
 drivers/scsi/mpt2sas/mpt2sas_base.h | 2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/isci/registers.h b/drivers/scsi/isci/registers.h
index 97f3ceb..63468cf 100644
--- a/drivers/scsi/isci/registers.h
+++ b/drivers/scsi/isci/registers.h
@@ -652,7 +652,7 @@ struct scu_iit_entry {
 
 
 /*
- * TODO: Where is the SAS_LNKTOV regsiter?
+ * TODO: Where is the SAS_LNKTOV register?
  * TODO: Where is the SAS_PHYTOV register? */
 
 #define SCU_SAS_TRANSMIT_IDENTIFICATION_SMP_TARGET_SHIFT            (1)
@@ -1827,7 +1827,7 @@ struct scu_peg_registers {
 };
 
 /**
- * struct scu_registers - SCU regsiters including both PEG registers if we turn
+ * struct scu_registers - SCU registers including both PEG registers if we turn
  *    on that compile option. All of these registers are in the memory mapped
  *    space returned from BAR1.
  *
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 97ea360..9cc79cf 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -1209,7 +1209,7 @@ void mpt2sas_ctl_add_to_event_log(struct MPT2SAS_ADAPTER *ioc,
     Mpi2EventNotificationReply_t *mpi_reply);
 
 void mpt2sas_enable_diag_buffer(struct MPT2SAS_ADAPTER *ioc,
-	u8 bits_to_regsiter);
+	u8 bits_to_register);
 
 /* transport shared API */
 u8 mpt2sas_transport_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 9a73c8b..b95f932 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1211,7 +1211,7 @@ void mpt3sas_ctl_add_to_event_log(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2EventNotificationReply_t *mpi_reply);
 
 void mpt3sas_enable_diag_buffer(struct MPT3SAS_ADAPTER *ioc,
-	u8 bits_to_regsiter);
+	u8 bits_to_register);
 int mpt3sas_send_diag_release(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type,
 	u8 *issue_reset);
 
-- 
2.5.0
