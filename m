From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 0/8] scsi: ufs: query support and other fixes
Date: Sun, 19 May 2013 13:51:35 +0530
Message-ID: <1368951703-2672-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:40714 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3ESIWC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 May 2013 04:22:02 -0400
Received: by mail-pa0-f54.google.com with SMTP id kx1so4788055pab.41
        for <linux-scsi@vger.kernel.org>; Sun, 19 May 2013 01:22:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Santosh Y <santoshsy@gmail.com>

Hi James,

Please merge the following patches to 'misc' branch.

Thanks,
Santosh

Dolev Raviv (3):
  scsi: ufs: add support for query requests
  scsi: ufs: Add support for sending NOP OUT UPIU
  scsi: ufs: Set fDeviceInit flag to initiate device initialization

Seungwon Jeon (4):
  scsi: ufs: wrap the i/o access operations
  scsi: ufs: amend interrupt configuration
  scsi: ufs: remove version check before IS reg clear
  scsi: ufs: rework link start-up process

Sujit Reddy Thumma (1):
  scsi: ufs: Fix the response UPIU length setting

 drivers/scsi/ufs/ufs.h    |  132 ++++-
 drivers/scsi/ufs/ufshcd.c | 1172 +++++++++++++++++++++++++++++++++++----------
 drivers/scsi/ufs/ufshcd.h |   47 +-
 drivers/scsi/ufs/ufshci.h |    7 +-
 4 files changed, 1085 insertions(+), 273 deletions(-)

-- 
1.8.2.3

