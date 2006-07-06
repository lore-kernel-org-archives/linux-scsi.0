From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/15] lpfc 8.1.7 patches
Date: Thu, 06 Jul 2006 15:48:59 -0400
Message-ID: <1152215339.23158.17.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:12684 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750757AbWGFTst
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:48:49 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66JmmHh006899
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:48:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 8.1.7, which includes
the following changes:

 - Use mod_timer instead of add_timer in lpfc_els_timeout_handler
 - Standardize the driver on a single define for the maximum supported targets
 - Fix memory leak and cleanup code related to per ring lookup array.
 - Fixed infinite retry of REG_LOGIN mailbox failed due to MBXERR_RPI_FULL
 - Issue DOWN_LINK prior to INIT_LINK to work around link failure issue
 - Fix txcmplq related panics on heavy IO while downloading firmware
 - Correct bogus nodev_tmo message on NPort that changes its NPort Id
 - Consolidate dma buf cleanup into a separate function
 - Fix panic in lpfc_sli_validate_fcp_iocb due to access of scsi_cmnd after
   returning it to the midlayer
 - Adding new issue_reset sysfs attribute 
 - Remove depricated sysfs attribute board_online, as it's replaced by the new
   issue_reset attribute
 - Correct the wait in attachment that delays for topology discovery
 - Add lpfc_sli_flush_mbox_queue() function and use it in lpfc_offline() call
   to avoid deadlock on thread block.
 - Misc Fixes:
     - Fix some sparse warnings - casts of address space
     - Fix handling of the adapter registration string. Each invocation
       was byteswapping, so every other adapter init attempt failed.
     - Correct comments and default value for the lpfc_max_luns parameter
 - Change version number to 8.1.7

-- james s



