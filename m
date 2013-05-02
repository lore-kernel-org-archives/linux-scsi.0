From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 0/3] scsi: ufs: Platform and Query updates
Date: Thu,  2 May 2013 17:25:33 +0530
Message-ID: <1367495736-8927-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:41018 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822Ab3EBL41 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 May 2013 07:56:27 -0400
Received: by mail-da0-f48.google.com with SMTP id h32so278154dak.21
        for <linux-scsi@vger.kernel.org>; Thu, 02 May 2013 04:56:26 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Santosh Y <santoshsy@gmail.com>

Hi James,

Please merge the following patches to scsi tree.

Thanks,
Santosh


Dolev Raviv (1):
  scsi: ufs: add support for query requests

Vinayak Holikatti (2):
  ufs: Add Platform glue driver for ufshcd
  ufs: Correct the expected data transfersize

 drivers/scsi/ufs/Kconfig         |  12 ++
 drivers/scsi/ufs/Makefile        |   1 +
 drivers/scsi/ufs/ufs.h           | 122 ++++++++++-
 drivers/scsi/ufs/ufshcd-pltfrm.c | 217 +++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c        | 443 +++++++++++++++++++++++++++++++--------
 drivers/scsi/ufs/ufshcd.h        |  22 +-
 drivers/scsi/ufs/ufshci.h        |   2 +-
 7 files changed, 717 insertions(+), 102 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.c

-- 
1.8.1.2

