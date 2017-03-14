From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 0/9] be2iscsi: driver update 11.4.0.0
Date: Tue, 14 Mar 2017 13:31:25 +0530
Message-ID: <1489478494-5432-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:36283 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbdCNIBy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Mar 2017 04:01:54 -0400
Received: by mail-wr0-f171.google.com with SMTP id u108so118192881wrb.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 01:01:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

This patch is generated against for-next branch.

Jitendra Bhivare (9):
  be2iscsi: Check tag in beiscsi_mccq_compl_wait
  be2iscsi: Fix closing of connection
  be2iscsi: Replace spin_unlock_bh with spin_lock
  scsi_transport_iscsi: Use flush_work in iscsi_remove_session
  be2iscsi: Increase HDQ default queue size
  be2iscsi: Use num_cons field in Rx CQE
  be2iscsi: Remove free_list for ASYNC handles
  be2iscsi: Check size before copying ASYNC handle
  be2iscsi: Update driver version

 drivers/scsi/be2iscsi/be.h          |   1 -
 drivers/scsi/be2iscsi/be_cmds.c     |   6 +
 drivers/scsi/be2iscsi/be_cmds.h     |  63 ++++-----
 drivers/scsi/be2iscsi/be_iscsi.c    |  98 ++++++++------
 drivers/scsi/be2iscsi/be_main.c     | 257 ++++++++++++++++--------------------
 drivers/scsi/be2iscsi/be_main.h     |  15 +--
 drivers/scsi/be2iscsi/be_mgmt.c     | 127 +++++++++---------
 drivers/scsi/be2iscsi/be_mgmt.h     |  30 +----
 drivers/scsi/scsi_transport_iscsi.c |   3 +-
 9 files changed, 283 insertions(+), 317 deletions(-)

-- 
2.7.4
