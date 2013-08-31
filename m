From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 0/6] scsi: ufs: ufshcd updates and fixes
Date: Sat, 31 Aug 2013 21:40:18 +0530
Message-ID: <1377965424-30991-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63178 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3HaQKr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Aug 2013 12:10:47 -0400
Received: by mail-pd0-f175.google.com with SMTP id q10so3037015pdj.20
        for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2013 09:10:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Santosh Y <santoshsy@gmail.com>

Hi James,

Please apply the following patches to 'misc' branch.

Thanks,
Santosh

Seungwon Jeon (6):
  scsi: ufs: find out sense data over scsi status values
  scsi: ufs: fix the setting interrupt aggregation counter
  scsi: ufs: add dme configuration primitives
  scsi: ufs: add unipro attribute IDs
  scsi: ufs: add operation for the uic power mode change
  scsi: ufs: configure the attribute for power mode

 drivers/scsi/ufs/ufs.h    |   1 +
 drivers/scsi/ufs/ufshcd.c | 328 +++++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.h |  54 ++++++++
 drivers/scsi/ufs/ufshci.h |  22 +++-
 drivers/scsi/ufs/unipro.h | 151 +++++++++++++++++++++
 5 files changed, 507 insertions(+), 49 deletions(-)
 create mode 100644 drivers/scsi/ufs/unipro.h

-- 
1.8.4

