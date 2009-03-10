From: Stoyan Gaydarov <stoyboyker@gmail.com>
Subject: [PATCH 20/25] [scsi] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:45 -0500
Message-ID: <1236661850-8237-21-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-5-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-6-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-9-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-10-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-11-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-12-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-13-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-14-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-15-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-16-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-17-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-18-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-19-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-20-git-send-email-stoyboyker@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:28373 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbZCJFMD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2009 01:12:03 -0400
In-Reply-To: <1236661850-8237-20-git-send-email-stoyboyker@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-scsi@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index a730248..ccdc1eb 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -6343,8 +6343,7 @@ lpfc_cmpl_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 {
 	struct ls_rjt stat;
 
-	if ((cmdiocb->iocb_flag & LPFC_IO_FABRIC) != LPFC_IO_FABRIC)
-		BUG();
+	BUG_ON((cmdiocb->iocb_flag & LPFC_IO_FABRIC) != LPFC_IO_FABRIC);
 
 	switch (rspiocb->iocb.ulpStatus) {
 		case IOSTAT_NPORT_RJT:
-- 
1.6.1.3

