From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 0/22] lpfc 8.1.2: driver update (repost)
Date: Tue, 28 Feb 2006 19:25:09 -0500
Message-ID: <20060301002509.GA15333@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:40358 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S932734AbWCAAZM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:12 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210P9NI015339
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:09 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210P9YA015338
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:09 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


James Smart is away this week so I'm covering this for him.

We're reposting the lpfc 8.1.2 patches because the earlier set had
some patch format issues that preventing them from applying.  These
are exactly the same changes as the previously posted 8.1.2, but
without the formatting issue.

This patch set updates the lpfc driver to revision 8.1.2, which
includes the following changes:

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

- Jamie Wellnitz
