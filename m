From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/7] lpfc 8.3.36: Correct buffer length overrun
Date: Wed, 31 Oct 2012 14:45:09 -0400
Message-ID: <1351709109.957.20.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:15773 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab2JaSpw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2012 14:45:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Correct buffer length overrun

Reported via: https://bugzilla.kernel.org/show_bug.cgi?id=48871


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-10-31 12:42:16.691115051 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-10-31 12:45:32.578119513 -0400
@@ -3854,7 +3854,7 @@ static void
 lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 {
 	char port_name;
-	char message[80];
+	char message[128];
 	uint8_t status;
 	struct lpfc_acqe_misconfigured_event *misconfigured;
 



