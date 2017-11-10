From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 00/17] lpfc updates for 11.4.0.5
Date: Thu,  9 Nov 2017 17:08:17 -0800
Message-ID: <20171110010834.4542-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:51091 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755255AbdKJBIn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 20:08:43 -0500
Received: by mail-qt0-f172.google.com with SMTP id d9so10056618qtd.7
        for <linux-scsi@vger.kernel.org>; Thu, 09 Nov 2017 17:08:43 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>

This patch set provides a number of bug fixes and additions to
the driver.

The patches were cut against the Martin's 4.15/scsi-queue tree.
There are no outside dependencies and are expected to be pulled
via Martins tree.

v2:
 Rework patch 1 per review
 Add signed-by's on other patches


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
 drivers/scsi/lpfc/lpfc_els.c     |  71 ++++++------
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
 17 files changed, 588 insertions(+), 249 deletions(-)

-- 
2.13.1
