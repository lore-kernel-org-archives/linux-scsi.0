From: james.smart@broadcom.com (James Smart)
Subject: [PATCH v3 00/17] lpfc: Update driver to version 11.2.0.2
Date: Thu, 13 Oct 2016 15:06:01 -0700
Message-ID: <58000549.uzQNZmDWt9VDYdS0%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([199.3.246.86]:36873 "EHLO
        sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756957AbcJMWQf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 18:16:35 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp2.avagotech.com (Postfix) with SMTP id CF9E41209C7
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:06:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 11.2.0.2

The patches were cut against scsi-misc

James Smart (17):
  Fix few small typos in lpfc_scsi.c
       originally posted by Milan Gandhi
  lpfc: Correct embedded io wq element size
  lpfc: Fix sg_reset on SCSI device causing kernel crash
  lpfc: Set driver environment data on adapter
  lpfc: Make lpfc_prot_mask and lpfc_prot_guard per hba parameters
  lpfc: Code clean up for lpfc_iocb_cnt parameter
  lpfc: Code cleanup for lpfc_enable_rrq parameter
  lpfc: Code cleanup for lpfc_aer_support parameter
  lpfc: Code cleanup for lpfc_topology parameter
  lpfc: Code cleanup for lpfc_max_scsicmpl_time parameter
  lpfc: Code cleanup for lpfc_sriov_nr_virtfn parameter
  lpfc: Revise strings with full lpfc parameter name
  lpfc: Fix lost target in pt-to-pt connect
  lpfc: Correct panics with eh_timeout and eh_deadline
  lpfc: Synchronize link speed with boot driver
  lpfc: Fix fw download on SLI-4 FC adapters
  lpfc: lpfc version changed to 11.2.0.2

 drivers/scsi/lpfc/lpfc.h         |   6 ++
 drivers/scsi/lpfc/lpfc_attr.c    | 160 +++++++++++----------------------------
 drivers/scsi/lpfc/lpfc_bsg.c     |  45 +++++++++++
 drivers/scsi/lpfc/lpfc_bsg.h     |  10 +++
 drivers/scsi/lpfc/lpfc_crtn.h    |   2 -
 drivers/scsi/lpfc/lpfc_els.c     |   2 +-
 drivers/scsi/lpfc/lpfc_hw4.h     |  18 ++++-
 drivers/scsi/lpfc/lpfc_init.c    | 116 ++++++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_scsi.c    |  49 +++++++-----
 drivers/scsi/lpfc/lpfc_sli.c     |  41 +++++++++-
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 11 files changed, 276 insertions(+), 175 deletions(-)

-- 
2.5.0


