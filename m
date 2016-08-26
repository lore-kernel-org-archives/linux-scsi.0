From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 0/3] be2iscsi: cleanup of 11.2 in 4.9/scsi-queue
Date: Fri, 26 Aug 2016 15:09:05 +0530
Message-ID: <1472204348-5960-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34488 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752364AbcHZJjc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2016 05:39:32 -0400
Received: by mail-pf0-f182.google.com with SMTP id p64so27184175pfb.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2016 02:39:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, julia.lawall@lip6.fr, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

These patches address some auto built issues of 11.2.0.0 be2iscsi
committed in 4.9/scsi-queue.

v2 changes:
Added NULL check for pwrb_handle in PATCH v2 2/3

Christophe JAILLET (1):
  be2iscsi: Fix error return code

Jitendra Bhivare (2):
  be2iscsi: Remove redundant iscsi_wrb desc memset
  be2iscsi: Add missing unlock for mbox_lock

 drivers/scsi/be2iscsi/be_main.c | 27 ++++++++++++++++-----------
 drivers/scsi/be2iscsi/be_mgmt.c |  7 +++----
 2 files changed, 19 insertions(+), 15 deletions(-)

-- 
2.7.4

