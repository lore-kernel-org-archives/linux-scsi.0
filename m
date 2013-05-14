From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 0/3] UFSHCD updates
Date: Tue, 14 May 2013 21:34:12 +0530
Message-ID: <1368547455-5211-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:58461 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab3ENQEo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 May 2013 12:04:44 -0400
Received: by mail-pb0-f44.google.com with SMTP id wz17so552339pbc.31
        for <linux-scsi@vger.kernel.org>; Tue, 14 May 2013 09:04:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Santosh Y <santoshsy@gmail.com>

Hi James,

Please merge the following patches to scsi tree.

Thanks,
Santosh

Geert Uytterhoeven (1):
  SCSI_UFSHCD should depend on SCSI_DMA

Sachin Kamat (1):
  ufs: Remove redundant platform_set_drvdata()

Sujit Reddy Thumma (1):
  Documentation: devicetree: Add DT bindings for UFS host controller

 Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt | 16 ++++++++++++++++
 drivers/scsi/ufs/Kconfig                                |  2 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                        |  1 -
 3 files changed, 17 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt

-- 
1.8.1.2

