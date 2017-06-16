From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/11] lpfc updates for 11.4.0.1
Date: Thu, 15 Jun 2017 22:56:40 -0700
Message-ID: <20170616055651.9674-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35972 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbdFPF5C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2017 01:57:02 -0400
Received: by mail-qt0-f193.google.com with SMTP id s33so7932200qtg.3
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2017 22:57:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>

This patch set provides a number of bug fixes.

The patches were cut against the Martin's 4.13/scsi-queue tree.
There are no outside dependencies. The patches should merge via
Martin's tree. 

James Smart (11):
  Fix system panic when express lane enabled.
  Fix nvme_info sysfs output to be consistent
  Vport creation is failing with "Link Down" error
  Reduce time spent in IRQ for received NVME commands
  Break up IO ctx list into a separate get and put list
  Fix SLI3 drivers attempting NVME ELS commands.
  Fix crash after firmware flash when IO is running.
  Fix crash doing IO with resets
  Fix crash in lpfc_sli_ringtxcmpl_put when nvmet gets an abort request.
  Driver responds LS_RJT to Beacon Off ELS - Linux
  lpfc: update to revision to 11.4.0.1

 drivers/scsi/lpfc/lpfc_attr.c    | 13 +++---
 drivers/scsi/lpfc/lpfc_debugfs.c | 11 ++++--
 drivers/scsi/lpfc/lpfc_els.c     | 38 +++++++++---------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  3 +-
 drivers/scsi/lpfc/lpfc_init.c    | 37 ++++++++++-------
 drivers/scsi/lpfc/lpfc_nvmet.c   | 85 ++++++++++++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_sli.c     | 27 ++++++-------
 drivers/scsi/lpfc/lpfc_sli4.h    |  9 +++--
 drivers/scsi/lpfc/lpfc_version.h |  2 +-
 9 files changed, 137 insertions(+), 88 deletions(-)

-- 
2.11.0
