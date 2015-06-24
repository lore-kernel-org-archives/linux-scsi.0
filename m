From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH] megaraid:Make functions static in the file megaraid_sas_base.c
Date: Wed, 24 Jun 2015 11:27:22 +0530
Message-ID: <05b203753393a523dfc3873996c3760c@mail.gmail.com>
References: <1435104805-11346-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1435104805-11346-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Uday Lingala <uday.lingala@avagotech.com>, JBottomley@odin.com, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: Nicholas Krause [mailto:xerofoify@gmail.com]
Sent: Wednesday, June 24, 2015 5:43 AM
To: kashyap.desai@avagotech.com
Cc: sumit.saxena@avagotech.com; uday.lingala@avagotech.com;
JBottomley@odin.com; megaraidlinux.pdl@avagotech.com;
linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH] megaraid:Make functions static in the file
megaraid_sas_base.c

This makes various functions that have no external callers outside their
definition/declaration in the file megaraid_sas_base.c to be declared as
static now.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
b/drivers/scsi/megaraid/megaraid_sas_base.c
index 4c3fc0e..dad2393 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -190,7 +190,7 @@ static int megasas_get_ld_vf_affiliation(struct
megasas_instance *instance,  int megasas_check_mpio_paths(struct
megasas_instance *instance,
 			     struct scsi_cmnd *scmd);

-void
+static void
 megasas_issue_dcmd(struct megasas_instance *instance, struct megasas_cmd
*cmd)  {
 	instance->instancet->fire_cmd(instance,
@@ -1698,7 +1698,7 @@ static int megasas_slave_alloc(struct scsi_device
*sdev)
 * @instance:				Adapter soft state
 *
 */
-void megasas_complete_outstanding_ioctls(struct megasas_instance
*instance)
+static void megasas_complete_outstanding_ioctls(struct megasas_instance
+*instance)
 {
 	int i;
 	struct megasas_cmd *cmd_mfi;
@@ -1856,7 +1856,7 @@ megasas_internal_reset_defer_cmds(struct
megasas_instance *instance);  static void
process_fw_state_change_wq(struct work_struct *work);

-void megasas_do_ocr(struct megasas_instance *instance)
+static void megasas_do_ocr(struct megasas_instance *instance)
 {
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS1064R) ||
 	(instance->pdev->device == PCI_DEVICE_ID_DELL_PERC5) ||

Acked-by: Sumit Saxena <sumit.saxena@avagotech.com>

--
2.1.4
