From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 15/22] lpfc 8.1.2 : Make lpfc_els_rsp_rps_acc and lpfc_els_rsp_rpl_acc
 static
Date: Wed, 08 Feb 2006 10:42:57 -0500
Message-ID: <43EA1181.4060708@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:49549 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030458AbWBHPnA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:43:00 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18Fgxrf011919
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:43:00 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Make lpfc_els_rsp_rps_acc and lpfc_els_rsp_rpl_acc static


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2668,7 +2668,7 @@ lpfc_els_rcv_lirr(struct lpfc_hba * phba
  	return 0;
  }

-void
+static void
  lpfc_els_rsp_rps_acc(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
  {
  	struct lpfc_sli *psli;
@@ -2795,7 +2795,7 @@ lpfc_els_rcv_rps(struct lpfc_hba * phba,
  	return 0;
  }

-int
+static int
  lpfc_els_rsp_rpl_acc(struct lpfc_hba * phba, uint16_t cmdsize,
  		 struct lpfc_iocbq * oldiocb, struct lpfc_nodelist * ndlp)
  {

