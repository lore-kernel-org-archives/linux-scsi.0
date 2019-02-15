From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: mpt3sas: Add missing breaks in switch statements
Date: Fri, 15 Feb 2019 15:54:14 -0600
Message-ID: <20190215215414.GA10944@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org

Fix the following warnings by adding the proper missing breaks:

drivers/scsi/mpt3sas/mpt3sas_base.c: In function ‘_base_display_OEMs_branding’:
drivers/scsi/mpt3sas/mpt3sas_base.c:3548:4: warning: this statement may fall through [-Wimplicit-fallthrough=]
    switch (ioc->pdev->subsystem_device) {
    ^~~~~~
drivers/scsi/mpt3sas/mpt3sas_base.c:3566:3: note: here
   case MPI2_MFGPAGE_DEVID_SAS2308_2:
   ^~~~
drivers/scsi/mpt3sas/mpt3sas_base.c:3567:4: warning: this statement may fall through [-Wimplicit-fallthrough=]
    switch (ioc->pdev->subsystem_device) {
    ^~~~~~
drivers/scsi/mpt3sas/mpt3sas_base.c:3601:3: note: here
   case MPI25_MFGPAGE_DEVID_SAS3008:
   ^~~~
drivers/scsi/mpt3sas/mpt3sas_base.c:3735:4: warning: this statement may fall through [-Wimplicit-fallthrough=]
    switch (ioc->pdev->subsystem_device) {
    ^~~~~~
drivers/scsi/mpt3sas/mpt3sas_base.c:3745:3: note: here
   case MPI2_MFGPAGE_DEVID_SAS2308_2:
   ^~~~
drivers/scsi/mpt3sas/mpt3sas_base.c:3746:4: warning: this statement may fall through [-Wimplicit-fallthrough=]
    switch (ioc->pdev->subsystem_device) {
    ^~~~~~
drivers/scsi/mpt3sas/mpt3sas_base.c:3768:3: note: here
   default:
   ^~~~~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

This patch is part of the ongoing efforts to enable
-Wimplicit-fallthrough.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0a6cb8f0680c..e57774472e75 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3563,6 +3563,7 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 					 ioc->pdev->subsystem_device);
 				break;
 			}
+			break;
 		case MPI2_MFGPAGE_DEVID_SAS2308_2:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT2SAS_INTEL_RS25GB008_SSDID:
@@ -3598,6 +3599,7 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 					 ioc->pdev->subsystem_device);
 				break;
 			}
+			break;
 		case MPI25_MFGPAGE_DEVID_SAS3008:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT3SAS_INTEL_RMS3JC080_SSDID:
@@ -3742,6 +3744,7 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 					 ioc->pdev->subsystem_device);
 				break;
 			}
+			break;
 		case MPI2_MFGPAGE_DEVID_SAS2308_2:
 			switch (ioc->pdev->subsystem_device) {
 			case MPT2SAS_HP_2_4_INTERNAL_SSDID:
@@ -3765,6 +3768,7 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
 					 ioc->pdev->subsystem_device);
 				break;
 			}
+			break;
 		default:
 			ioc_info(ioc, "HP SAS HBA: Subsystem ID: 0x%X\n",
 				 ioc->pdev->subsystem_device);
-- 
2.20.1
