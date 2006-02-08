From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/22] lpfc 8.1.2 driver update
Date: Wed, 08 Feb 2006 10:40:44 -0500
Message-ID: <43EA10FC.3030008@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:17037 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030432AbWBHPky
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:40:54 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18Fekrf011782
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:40:47 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This patch set updates the lpfc driver to revision 8.1.2, which includes
the following changes:

   - Remove several unused prototypes
   - Remove unreferenced cfg_fcp_bind_method from struct lpfc_hba
   - Remove unused SLI_IOCB_HIGH_PRIORITY
   - Handling of ELS commands RRQ, RPS, RPL and LIRR correctly
   - Fixed a race condition in the PLOGI retry logic.
   - Explicitly initialize the skip_post argument to lpfc_sli_send_reset
     on a ERATT interrupt.
   - Fixed system panic in lpfc_sli_brdreset during dynamic add of LP11K
   - Fixed a double insertion of mail box object to the SLI mailbox list.
   - Add module parameter to limit number of outstanding commands per lpfc HBA
   - Misc FC Discovery changes
   - Correct use of the hostdata field in scsi_host
   - Remove hba_list from struct lpfc_hba
   - Add ERROR and WARM_START modes for diagnostic purposes.
   - Added support for FAN
   - Make lpfc_els_rsp_rps_acc and lpfc_els_rsp_rpl_acc static
   - Code style changes for Discovery code
   - Allow turning on internal loop-back mode
   - Code cleanup of lpfc_mbx_cmpl_config_link
   - Fixed module parameter descriptions.
   - Fix panic caused by HBA resets and target side cable pulls
   - Modify RSCN handling to unregister rpis on lost FCP_TARGETs immediately
   - Change version number to 8.1.2

-- james s


