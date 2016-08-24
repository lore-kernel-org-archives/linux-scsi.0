From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 0/3] be2iscsi: cleanup of 11.2 in 4.9/scsi-queue
Date: Wed, 24 Aug 2016 15:03:12 +0530
Message-ID: <1472031195-14556-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34737 "EHLO
        mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752974AbcHXJf7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2016 05:35:59 -0400
Received: by mail-pa0-f46.google.com with SMTP id fi15so4961612pac.1
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2016 02:35:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, julia.lawall@lip6.fr, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

These patches address some auto built issues of 11.2.0.0 be2iscsi
committed in 4.9/scsi-queue.

Christophe JAILLET (1):
  be2iscsi: Fix error return code

Jitendra Bhivare (2):
  be2iscsi: Remove redundant iscsi_wrb desc memset
  be2iscsi: Add missing unlock for mbox_lock

 drivers/scsi/be2iscsi/be_main.c | 23 +++++++++++++----------
 drivers/scsi/be2iscsi/be_mgmt.c |  7 +++----
 2 files changed, 16 insertions(+), 14 deletions(-)

-- 
1.9.1

