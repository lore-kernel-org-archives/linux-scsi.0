From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 00/10] be2iscsi: driver update 11.4.0.1
Date: Tue, 10 Oct 2017 16:18:10 +0530
Message-ID: <1507632500-26445-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:45896 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751398AbdJJKsi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 06:48:38 -0400
Received: by mail-pf0-f175.google.com with SMTP id d28so2100494pfe.2
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2017 03:48:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

This patch is generated against for-next branch.

Jitendra Bhivare (10):
  be2iscsi: Fix boot flags in sysfs
  be2iscsi: Fix return value in mgmt_open_connection
  be2iscsi: Free msi_name and disable HW intr
  be2iscsi: Fix _modify_eq_delay buffer overflow
  be2iscsi: Fix _get_initname buffer overflow
  be2iscsi: Modify IOCTL to fetch user configured IQN
  be2iscsi: Add cmd to set host data
  be2iscsi: Fix misc static analysis errors
  be2iscsi: Remove A-circumflex character in copyright marking
  scsi: be2iscsi: Update driver version

 drivers/scsi/be2iscsi/be.h       |  19 ++-
 drivers/scsi/be2iscsi/be_cmds.c  |  55 +++++++-
 drivers/scsi/be2iscsi/be_cmds.h  |  48 ++++---
 drivers/scsi/be2iscsi/be_iscsi.c |  54 ++------
 drivers/scsi/be2iscsi/be_iscsi.h |   2 +-
 drivers/scsi/be2iscsi/be_main.c  | 102 ++++++++------
 drivers/scsi/be2iscsi/be_main.h  |  49 +------
 drivers/scsi/be2iscsi/be_mgmt.c  | 278 ++++++++++++++++++++++-----------------
 drivers/scsi/be2iscsi/be_mgmt.h  |  10 +-
 9 files changed, 323 insertions(+), 294 deletions(-)

-- 
2.7.4
