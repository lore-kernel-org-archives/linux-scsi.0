From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [lpfc 00/19] lpfc updates.
Date: Tue,  4 Apr 2017 10:16:53 -0700
Message-ID: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:38139 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754959AbdDDRZh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 13:25:37 -0400
Received: from pallmd1.broadcom.com (pallmd1.ash.broadcom.net [10.85.232.165])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id CCCBF30C0A2
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2017 10:17:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>

This patch set includes patches to fix driver load/unload that have been partiallty submitted by other users.
This patch set is supplying the abort handline for nvme that was missing.


Dick Kennedy (19):
  Fix advertised max_sgl_segment count for NVMET
  Fixes after reviewing last set of patches. Minor fixes to previous
    patches
  Fix spelling in comments.
  Fix PRLI ACC rsp for NVME
  Fix driver unload/reload operation.
  Fix discovery error handling in NVME initiator
  Fix driver usage of 128B WQEs when WQ_CREATE is V1.
  Fix nvme initiator handling when CONFIG_LPFC_NVME_INITIATOR is not
    enabled.
  Fix Kconfig defines.
  Remove hba lock from NVMET isssue WQE
  Add NVMET changes to interface with 4.11 kernel
  cannot establish connection with target that sends PRLI in PT2PT
  Fix driver load issues when MRQ=8
  Fix crash after issuing lip reset
  Fix max_sgl_segments settings for NVME / NVMET
  Add Fabric assigned WWN support.
  Fix implicit logo and RSCN handling for NVMET
  Update ABORT processing for NVMET
  lpfc revison 11.2.0.12

 drivers/scsi/lpfc/lpfc.h           |   5 +-
 drivers/scsi/lpfc/lpfc_attr.c      |  16 +-
 drivers/scsi/lpfc/lpfc_bsg.c       |   4 +
 drivers/scsi/lpfc/lpfc_crtn.h      |   9 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  68 ++++--
 drivers/scsi/lpfc/lpfc_debugfs.c   |  69 ++++--
 drivers/scsi/lpfc/lpfc_disc.h      |   1 +
 drivers/scsi/lpfc/lpfc_els.c       |  68 +++---
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 131 +++++++----
 drivers/scsi/lpfc/lpfc_hw.h        |   3 +
 drivers/scsi/lpfc/lpfc_hw4.h       |   4 +
 drivers/scsi/lpfc/lpfc_init.c      | 169 ++++++++++-----
 drivers/scsi/lpfc/lpfc_mbox.c      |   7 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |   8 +-
 drivers/scsi/lpfc/lpfc_nvme.c      | 139 ++++++++----
 drivers/scsi/lpfc/lpfc_nvme.h      |   7 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     | 434 ++++++++++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_nvmet.h     |  13 +-
 drivers/scsi/lpfc/lpfc_sli.c       |  22 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |   2 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |   3 +-
 22 files changed, 870 insertions(+), 314 deletions(-)

-- 
2.1.0
