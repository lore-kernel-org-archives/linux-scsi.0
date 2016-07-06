From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 06/21] lpfc: Add sysfs proc_name support
Date: Wed, 06 Jul 2016 12:35:59 -0700
Message-ID: <577d5d9f.+1zwDMnCrvR4Oepn%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37321 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbcGFTgE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:04 -0400
Received: by mail-wm0-f45.google.com with SMTP id a66so5729345wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:04 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id cx8sm24178wjb.37.2016.07.06.12.36.01
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add sysfs proc_name support

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 3bd0be6..12b8e82 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5886,6 +5886,7 @@ lpfc_disable_oas_lun(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
 struct scsi_host_template lpfc_template_s3 = {
 	.module			= THIS_MODULE,
 	.name			= LPFC_DRIVER_NAME,
+	.proc_name		= LPFC_DRIVER_NAME,
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_queuecommand,
 	.eh_abort_handler	= lpfc_abort_handler,
@@ -5910,6 +5911,7 @@ struct scsi_host_template lpfc_template_s3 = {
 struct scsi_host_template lpfc_template = {
 	.module			= THIS_MODULE,
 	.name			= LPFC_DRIVER_NAME,
+	.proc_name		= LPFC_DRIVER_NAME,
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_queuecommand,
 	.eh_abort_handler	= lpfc_abort_handler,
@@ -5935,6 +5937,7 @@ struct scsi_host_template lpfc_template = {
 struct scsi_host_template lpfc_vport_template = {
 	.module			= THIS_MODULE,
 	.name			= LPFC_DRIVER_NAME,
+	.proc_name		= LPFC_DRIVER_NAME,
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_queuecommand,
 	.eh_abort_handler	= lpfc_abort_handler,
-- 
2.5.0

