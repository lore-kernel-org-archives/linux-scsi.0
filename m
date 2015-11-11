From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 24/25] mpt3sas: Added SCSI_MPT3SAS_MERGED config option
Date: Wed, 11 Nov 2015 17:30:40 +0530
Message-ID: <1447243241-10912-25-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

This Kconfig option is only used for legacy mpt2sas/mpt3sas
interoperability.

Once this config is set, out of box driver mpt2sas and mpt3sas
can reconginize difference between merged and legacy inbox driver.
Used only to interface gracefully between old mpt2sas/mpt3sas and
merged mpt3sas driver.

Allways set for merged mpt3sas driver.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/mpt3sas/Kconfig b/drivers/scsi/mpt3sas/Kconfig
index 2906146..ad171c4 100644
--- a/drivers/scsi/mpt3sas/Kconfig
+++ b/drivers/scsi/mpt3sas/Kconfig
@@ -45,9 +45,20 @@ config SCSI_MPT3SAS
 	depends on PCI && SCSI
 	select SCSI_SAS_ATTRS
 	select RAID_ATTRS
+	select SCSI_MPT3SAS_MERGED
 	---help---
 	This driver supports PCI-Express SAS 12Gb/s Host Adapters.
 
+config SCSI_MPT3SAS_MERGED
+	bool "Only used for legacy mpt2sas/mpt3sas interoperability"
+	---help---
+	Once this config is set, out of box driver mpt2sas and mpt3sas
+	can recongnize difference between merged and legacy inbox driver.
+	Used only to interface gracefully between old mpt2sas/mpt3sas and
+	merged mpt3sas driver.
+
+	Always set for merged mpt3sas driver.
+
 config SCSI_MPT2SAS_MAX_SGE
 	int "LSI MPT Fusion SAS 2.0 Max number of SG Entries (16 - 256)"
 	depends on PCI && SCSI && SCSI_MPT3SAS
-- 
2.0.2
