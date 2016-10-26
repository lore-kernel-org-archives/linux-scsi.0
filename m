From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 04/11] mpt3sas: Removing unused macro "MPT_DEVICE_TLR_ON"
Date: Wed, 26 Oct 2016 13:34:35 +0530
Message-ID: <1477469082-32395-5-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1477469082-32395-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477469082-32395-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, Sathya Prakash <sathya.prakash@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Removing macro "MPT_DEVICE_TLR_ON" defined in header file as its unused

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 4221a4d..e923c91 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -375,7 +375,6 @@ struct MPT3SAS_TARGET {
  * per device private data
  */
 #define MPT_DEVICE_FLAGS_INIT		0x01
-#define MPT_DEVICE_TLR_ON		0x02
 
 #define MFG_PAGE10_HIDE_SSDS_MASK	(0x00000003)
 #define MFG_PAGE10_HIDE_ALL_DISKS	(0x00)
-- 
2.4.3
