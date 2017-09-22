From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/19] lpfc updates for 11.4.0.4
Date: Thu, 21 Sep 2017 23:17:22 -0700
Message-ID: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33030 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdIVGR4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:17:56 -0400
Received: by mail-pf0-f194.google.com with SMTP id h4so96204pfk.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:17:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>

This patch set provides a number of bug fixes and additions to
the driver.

The patches were cut against the Martin's 4.14/scsi-queue tree.
There are no outside dependencies.


  lpfc: Fix crash in pci hot plug situations
  lpfc: Fix crash receiving ELS while detaching driver
  lpfc: Fix lpfc nvme host rejecting IO with Not Ready message
  lpfc: Fix warning messages when NVME_TARGET_FC not defined
  lpfc: PLOGI failures during NPIV testing
  lpfc: Make ktime sampling more accurate
  lpfc: Move CQ processing to a soft IRQ
  lpfc: Fix FCP hba_wqidx assignment
  lpfc: Revise NVME module parameter descriptions for better clarity
  lpfc: Reduce log spew on controller reconnects
  lpfc: Set missing abort context
  lpfc: Fix oops if nvmet_fc_register_targetport fails
  lpfc: Disable NPIV support if NVME is enabled
  lpfc: Fix crash in lpfc_nvme_fcp_io_submit during LIP
  lpfc: Fix secure firmware updates
  lpfc: Ensure io aborts interlocked with the target.
  lpfc: Extend RDP support
  lpfc: Fix oops of nvme host during driver unload.
  lpfc: change version to 11.4.0.4


 drivers/scsi/lpfc/lpfc.h           |   3 +
 drivers/scsi/lpfc/lpfc_attr.c      |  10 +-
 drivers/scsi/lpfc/lpfc_bsg.c       |   4 +-
 drivers/scsi/lpfc/lpfc_els.c       |  19 ++--
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   8 +-
 drivers/scsi/lpfc/lpfc_hw4.h       |   2 +-
 drivers/scsi/lpfc/lpfc_init.c      |  30 ++++--
 drivers/scsi/lpfc/lpfc_nportdisc.c |   2 +-
 drivers/scsi/lpfc/lpfc_nvme.c      | 169 +++++++++++++++++++----------
 drivers/scsi/lpfc/lpfc_nvmet.c     | 148 +++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_sli.c       | 216 +++++++++++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_sli4.h      |   4 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |   9 ++
 14 files changed, 409 insertions(+), 217 deletions(-)

-- 
2.13.1
