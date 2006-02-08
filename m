From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 12/22] lpfc 8.1.2 : Remove hba_list from struct lpfc_hba
Date: Wed, 08 Feb 2006 10:42:41 -0500
Message-ID: <43EA1171.3060608@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46477 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030450AbWBHPmo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:42:44 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18Fghrf011901
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:42:44 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Remove hba_list from struct lpfc_hba

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -169,7 +169,6 @@ struct lpfc_sysfs_mbox {
  };

  struct lpfc_hba {
-	struct list_head hba_list;	/* List of hbas/ports */
  	struct lpfc_sli sli;
  	struct lpfc_sli2_slim *slim2p;
  	dma_addr_t slim2p_mapping;

