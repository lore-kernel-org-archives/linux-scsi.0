From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/22] lpfc 8.1.2 : Remove unreferenced cfg_fcp_bind_method
 from struct lpfc_hba
Date: Wed, 08 Feb 2006 10:41:00 -0500
Message-ID: <43EA110C.9080808@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:19853 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030436AbWBHPlF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:41:05 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18Ff3rf011797
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:41:03 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Remove unreferenced cfg_fcp_bind_method from struct lpfc_hba

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -290,7 +290,6 @@ struct lpfc_hba {
  	uint32_t cfg_cr_delay;
  	uint32_t cfg_cr_count;
  	uint32_t cfg_fdmi_on;
-	uint32_t cfg_fcp_bind_method;
  	uint32_t cfg_discovery_threads;
  	uint32_t cfg_max_luns;
  	uint32_t cfg_poll;

