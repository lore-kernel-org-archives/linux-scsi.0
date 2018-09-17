From: Joe Perches <joe@perches.com>
Subject: [PATCH 7/7] mpt3sas: Remove unused macro MPT3SAS_FMT
Date: Mon, 17 Sep 2018 08:01:14 -0700
Message-ID: <b2223bcc61daab4132ece3867cb93ee0426707dd.1537183088.git.joe@perches.com>
References: <cover.1537183087.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1537183087.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

All the uses have been removed, delete the macro.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 941a4faf20be..8f1d6b071b39 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -158,8 +158,6 @@ struct mpt3sas_nvme_cmd {
 /*
  * logging format
  */
-#define MPT3SAS_FMT			"%s: "
-
 #define ioc_err(ioc, fmt, ...)						\
 	pr_err("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
 #define ioc_notice(ioc, fmt, ...)					\
-- 
2.15.0
