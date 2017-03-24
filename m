From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v3 00/10] be2iscsi: driver update 11.4.0.0
Date: Fri, 24 Mar 2017 14:11:39 +0530
Message-ID: <1490344909-29541-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34743 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753396AbdCXImc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2017 04:42:32 -0400
Received: by mail-qk0-f176.google.com with SMTP id p64so5688087qke.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2017 01:42:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thenzl@redhat.com, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

This patch is generated against for-next branch.

v3 changes:
 be2iscsi: Fix closing of connection
 	- Fixed per Tomas's review comments.

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
