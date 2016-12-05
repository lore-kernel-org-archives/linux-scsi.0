From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 00/12] be2iscsi: driver update 11.2.1.0
Date: Mon,  5 Dec 2016 13:36:39 +0530
Message-ID: <1480925211-13223-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:36740 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbcLEIHD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 03:07:03 -0500
Received: by mail-qk0-f171.google.com with SMTP id n21so338342594qka.3
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2016 00:07:03 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

This patch is generated against for-next branch.

Jitendra Bhivare (11):
  be2iscsi: Fix use of invalidate command table req
  be2iscsi: Fix for crash in beiscsi_eh_device_reset
  be2iscsi: Take iscsi_task ref in abort handler
  be2iscsi: Set WRB invalid bit for SkyHawk
  be2iscsi: Add checks to validate completions
  be2iscsi: Fix iSCSI cmd cleanup IOCTL
  be2iscsi: Remove redundant receive buffers posting
  be2iscsi: Remove unused struct members
  be2iscsi: Remove wq_name from beiscsi_hba
  be2iscsi: Add checks to validate CID alloc/free
  be2iscsi: Update driver version

Ketan Mukadam (1):
  be2iscsi: Add warning message for unsupported adapter

 drivers/scsi/be2iscsi/be.h       |   3 -
 drivers/scsi/be2iscsi/be_cmds.c  |  41 +++---
 drivers/scsi/be2iscsi/be_cmds.h  |  17 +--
 drivers/scsi/be2iscsi/be_iscsi.c | 165 ++++++++++++-----------
 drivers/scsi/be2iscsi/be_main.c  | 285 +++++++++++++++++++--------------------
 drivers/scsi/be2iscsi/be_main.h  |  44 ++----
 drivers/scsi/be2iscsi/be_mgmt.c  | 117 +++++++++-------
 drivers/scsi/be2iscsi/be_mgmt.h  |  98 +++-----------
 8 files changed, 344 insertions(+), 426 deletions(-)

-- 
1.8.3.1

