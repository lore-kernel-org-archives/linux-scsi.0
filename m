From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/19] lpfc updates for 11.4.0.7
Date: Wed, 24 Jan 2018 14:45:29 -0800
Message-ID: <20180124224548.9530-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:43611 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932860AbeAXWp6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jan 2018 17:45:58 -0500
Received: by mail-qt0-f194.google.com with SMTP id s3so14625206qtb.10
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2018 14:45:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>

This patch set provides a number of fixes for the driver.

The patches were cut against the Martin's 4.16/scsi-queue tree.
There are no outside dependencies and are expected to be pulled
via Martins tree.


James Smart (19):
  lpfc: Fix frequency of Release WQE CQEs
  lpfc: Increase CQ and WQ sizes for SCSI
  lpfc: move placement of target destroy on driver detach
  lpfc: correct debug counters for abort
  lpfc: Add WQ Full Logic for NVME Target
  lpfc: Fix PRLI handling when topology type changes
  lpfc: Fix IO failure during hba reset testing with nvme io.
  lpfc: Fix RQ empty firmware trap
  lpfc: Allow set of maximum outstanding SCSI cmd limit for a target
    parameter
  lpfc: Fix soft lockup in lpfc worker thread during LIP testing
  lpfc: Fix issue_lip if link is disabled
  lpfc: Indicate CONF support in NVMe PRLI
  lpfc: Fix SCSI io host reset causing kernel crash
  lpfc: Validate adapter support for SRIU option
  lpfc: Fix header inclusion in lpfc_nvmet
  lpfc: Treat SCSI Write operation Underruns as an error
  lpfc: Fix nonrecovery of NVME controller after cable swap.
  lpfc: update driver version to 11.4.0.7
  lpfc: Update modified files for 2018 Copyright

 drivers/scsi/lpfc/lpfc.h           |   3 +-
 drivers/scsi/lpfc/lpfc_attr.c      |  17 +++-
 drivers/scsi/lpfc/lpfc_crtn.h      |   3 +-
 drivers/scsi/lpfc/lpfc_els.c       |   5 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   7 +-
 drivers/scsi/lpfc/lpfc_hw4.h       |  14 +++-
 drivers/scsi/lpfc/lpfc_init.c      |  63 +++++++++++----
 drivers/scsi/lpfc/lpfc_mbox.c      |   6 +-
 drivers/scsi/lpfc/lpfc_mem.c       |  10 ++-
 drivers/scsi/lpfc/lpfc_nportdisc.c |   7 +-
 drivers/scsi/lpfc/lpfc_nvme.c      |  29 ++++---
 drivers/scsi/lpfc/lpfc_nvmet.c     | 155 +++++++++++++++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_nvmet.h     |  10 ++-
 drivers/scsi/lpfc/lpfc_scsi.c      |  49 ++++++++----
 drivers/scsi/lpfc/lpfc_sli.c       |  36 ++++++++-
 drivers/scsi/lpfc/lpfc_sli4.h      |  12 ++-
 drivers/scsi/lpfc/lpfc_version.h   |   4 +-
 17 files changed, 330 insertions(+), 100 deletions(-)

-- 
2.13.1
