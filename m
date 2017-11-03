From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/17] lpfc updates for 11.4.0.5
Date: Fri,  3 Nov 2017 15:56:11 -0700
Message-ID: <20171103225628.24716-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:56910 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756020AbdKCW4i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2017 18:56:38 -0400
Received: by mail-qk0-f173.google.com with SMTP id l194so5019762qke.13
        for <linux-scsi@vger.kernel.org>; Fri, 03 Nov 2017 15:56:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>

This patch set provides a number of bug fixes and additions to
the driver.

The patches were cut against the Martin's 4.15/scsi-queue tree.
There are no outside dependencies.

James Smart (17):
  lpfc: FLOGI failures are reported when connected to a private loop.
  lpfc: Expand WQE capability of every NVME hardware queue
  lpfc: Handle XRI_ABORTED_CQE in soft IRQ
  lpfc: Fix crash after bad bar setup on driver attachment
  lpfc: Fix NVME LS abort_xri
  lpfc: Raise maximum NVME sg list size for 256 elements
  lpfc: Driver fails to detect direct attach storage array
  lpfc: Fix display for debugfs queInfo
  lpfc: Adjust default value of lpfc_nvmet_mrq
  lpfc: Fix ndlp ref count for pt2pt mode issue RSCN
  lpfc: Linux LPFC driver does not process all RSCNs
  lpfc: correct port registrations with nvme_fc
  lpfc: Correct driver deregistrations with host nvme transport
  lpfc: Fix crash during driver unload with running nvme traffic
  lpfc: Fix driver handling of nvme resources during unload
  lpfc: small sg cnt cleanup
  lpfc: update driver version to 11.4.0.5

 drivers/scsi/lpfc/lpfc.h         |   4 +-
 drivers/scsi/lpfc/lpfc_attr.c    |  13 ++-
 drivers/scsi/lpfc/lpfc_crtn.h    |   2 +
 drivers/scsi/lpfc/lpfc_ct.c      |  19 +++
 drivers/scsi/lpfc/lpfc_debugfs.c |  16 +--
 drivers/scsi/lpfc/lpfc_disc.h    |   2 +
 drivers/scsi/lpfc/lpfc_els.c     |  79 +++++++------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  31 +++--
 drivers/scsi/lpfc/lpfc_hw4.h     |   6 +-
 drivers/scsi/lpfc/lpfc_init.c    | 243 +++++++++++++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_nvme.c    | 227 +++++++++++++++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_nvme.h    |   5 +-
 drivers/scsi/lpfc/lpfc_nvmet.c   |  13 ++-
 drivers/scsi/lpfc/lpfc_nvmet.h   |   4 +
 drivers/scsi/lpfc/lpfc_sli.c     | 169 ++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_sli4.h    |  10 +-
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 17 files changed, 595 insertions(+), 250 deletions(-)

-- 
2.13.1
