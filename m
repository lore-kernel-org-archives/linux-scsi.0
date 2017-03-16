From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 00/10] be2iscsi: driver update 11.4.0.0
Date: Thu, 16 Mar 2017 08:54:35 +0530
Message-ID: <1489634685-4975-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35291 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbdCPD0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2017 23:26:01 -0400
Received: by mail-wm0-f50.google.com with SMTP id u132so24934305wmg.0
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 20:25:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

This patch is generated against for-next branch.

v2 changes:
 +be2iscsi: Update Copyright

Jitendra Bhivare (10):
  be2iscsi: Check tag in beiscsi_mccq_compl_wait
  be2iscsi: Fix closing of connection
  be2iscsi: Replace spin_unlock_bh with spin_lock
  scsi_transport_iscsi: Use flush_work in iscsi_remove_session
  be2iscsi: Increase HDQ default queue size
  be2iscsi: Use num_cons field in Rx CQE
  be2iscsi: Remove free_list for ASYNC handles
  be2iscsi: Check size before copying ASYNC handle
  be2iscsi: Update Copyright
  be2iscsi: Update driver version

 drivers/scsi/be2iscsi/be.h          |  12 +-
 drivers/scsi/be2iscsi/be_cmds.c     |  17 ++-
 drivers/scsi/be2iscsi/be_cmds.h     |  74 +++++-----
 drivers/scsi/be2iscsi/be_iscsi.c    | 111 ++++++++-------
 drivers/scsi/be2iscsi/be_iscsi.h    |  13 +-
 drivers/scsi/be2iscsi/be_main.c     | 270 +++++++++++++++---------------------
 drivers/scsi/be2iscsi/be_main.h     |  28 ++--
 drivers/scsi/be2iscsi/be_mgmt.c     | 140 +++++++++----------
 drivers/scsi/be2iscsi/be_mgmt.h     |  43 ++----
 drivers/scsi/scsi_transport_iscsi.c |   3 +-
 10 files changed, 319 insertions(+), 392 deletions(-)

-- 
2.7.4
