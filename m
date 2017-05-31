From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/15] lpfc updates for 11.4.0.0
Date: Tue, 30 May 2017 23:04:24 -0700
Message-ID: <20170531060439.2073-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35961 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbdEaGEt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 02:04:49 -0400
Received: by mail-qt0-f193.google.com with SMTP id j13so806159qta.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2017 23:04:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>

This patch set provides a number of bug fixes, code cleanups, and error
handling in lpfc.

The patches were cut against the Martin's 4.12/scsi-fixes tree.
There are no outside dependencies. The patches should merge via
Martin's tree. 

James Smart (15):
  lpfc: Add nvme initiator devloss support
  lpfc: Fix transition nvme-i rport handling to nport only.
  lpfc: Fix nvme port role handling in sysfs and debugfs handlers.
  lpfc: Add changes to assist in NVMET debugging
  lpfc: Fix Lun Priority level shown as NA
  lpfc: Fix nvmet node ref count handling
  lpfc: Fix Port going offline after multiple resets.
  lpfc: Fix counters so outstandng NVME IO count is accurate
  lpfc: Fix return value of board_mode store routine in case of online
    failure
  lpfc: Fix crash on powering off BFS VM with passthrough device
  lpfc: Fix System panic after loading the driver
  lpfc: Null pointer dereference when log_verbose is set to 0xffffffff
  lpfc: Fix PRLI retry handling when target rejects it.
  lpfc: Fix vports not logging into target
  lpfc: update to revision to 11.4.0.0

 drivers/scsi/lpfc/lpfc.h         |  20 ++--
 drivers/scsi/lpfc/lpfc_attr.c    |  74 ++++++++------
 drivers/scsi/lpfc/lpfc_ct.c      |  31 +++---
 drivers/scsi/lpfc/lpfc_debugfs.c |  72 ++++++++------
 drivers/scsi/lpfc/lpfc_els.c     |  17 +++-
 drivers/scsi/lpfc/lpfc_hbadisc.c |  14 +--
 drivers/scsi/lpfc/lpfc_init.c    |  21 +++-
 drivers/scsi/lpfc/lpfc_nvme.c    | 178 ++++++++++++---------------------
 drivers/scsi/lpfc/lpfc_nvme.h    |   2 -
 drivers/scsi/lpfc/lpfc_nvmet.c   | 208 +++++++++++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_nvmet.h   |  14 +--
 drivers/scsi/lpfc/lpfc_scsi.c    |  19 +++-
 drivers/scsi/lpfc/lpfc_sli.c     |  19 +++-
 drivers/scsi/lpfc/lpfc_sli4.h    |   4 +-
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 15 files changed, 398 insertions(+), 297 deletions(-)

-- 
2.11.0
