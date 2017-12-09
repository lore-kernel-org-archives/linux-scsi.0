From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 0/9] lpfc updates for 11.4.0.6
Date: Fri,  8 Dec 2017 17:18:02 -0800
Message-ID: <20171209011811.23421-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33636 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752240AbdLIBSW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Dec 2017 20:18:22 -0500
Received: by mail-qt0-f196.google.com with SMTP id e2so29028507qti.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Dec 2017 17:18:22 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>

This patch set provides a number of bug fixes and 1 addition to
the driver.

The patches were cut against the Martin's 4.16/scsi-queue tree.
There are no outside dependencies and are expected to be pulled
via Martins tree.

James Smart (9):
  lpfc: Fix random heartbeat timeouts during heavy IO
  lpfc: Fix -EOVERFLOW behavior for NVMET and defer_rcv
  lpfc: Fix receive PRLI handling
  lpfc: Increase SCSI CQ and WQ sizes.
  lpfc: Fix SCSI LUN discovery when SCSI and NVME enabled
  lpfc: Fix issues connecting with nvme initiator
  lpfc: Fix infinite wait when driver unregisters a remote NVME port.
  lpfc: Beef up stat counters for debug
  lpfc: update driver version to 11.4.0.6

 drivers/scsi/lpfc/lpfc.h           |   2 +
 drivers/scsi/lpfc/lpfc_attr.c      |  46 ++++++-
 drivers/scsi/lpfc/lpfc_ct.c        |   1 +
 drivers/scsi/lpfc/lpfc_debugfs.c   |  49 +++++++-
 drivers/scsi/lpfc/lpfc_els.c       |  37 +++---
 drivers/scsi/lpfc/lpfc_init.c      |  81 ++++++++----
 drivers/scsi/lpfc/lpfc_nportdisc.c |  88 +++++++++----
 drivers/scsi/lpfc/lpfc_nvme.c      | 244 ++++++++++++++++++++-----------------
 drivers/scsi/lpfc/lpfc_nvme.h      |  16 ++-
 drivers/scsi/lpfc/lpfc_nvmet.c     |  58 +++++++--
 drivers/scsi/lpfc/lpfc_nvmet.h     |   6 +
 drivers/scsi/lpfc/lpfc_sli.c       |  24 ++--
 drivers/scsi/lpfc/lpfc_sli4.h      |   6 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 14 files changed, 451 insertions(+), 209 deletions(-)

-- 
2.13.1
