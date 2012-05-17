From: Girish K S <girish.shivananjappa@linaro.org>
Subject: [RFC V2 0/2] Add support for pci/non-pci probing for UFS
Date: Thu, 17 May 2012 16:52:04 +0530
Message-ID: <1337253726-2666-1-git-send-email-girish.shivananjappa@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39744 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284Ab2EQLW1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 07:22:27 -0400
Received: by dady13 with SMTP id y13so2301551dad.19
        for <linux-scsi@vger.kernel.org>; Thu, 17 May 2012 04:22:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, hch@infradead.org, patches@linaro.org, Girish K S <girish.shivananjappa@linaro.org>

The existing UFS driver is tightly bound to only pci specific devices.
It cannot work for non-pci devices.

"SCSI: UFS: Create separate UFS core and pci modules" patch splits the
ufs driver into core driver and pci probe driver.

"SCSI: UFS: Add platform support for ufs host controller" patch adds
support for the platform probing for non-pci devices

changes in v2:
		Reduced the number of patches from 4 to 2. merged the core and
pci probing modules as single patch. suggested by Christoph Hellwig.

changes in v1:
		Changes suggested by Namjae to split the existing driver as 3 independent
modules and retain the author's name in the files created by me.

Girish K S (2):
  SCSI: UFS: Create separate UFS core and pci modules
  SCSI: UFS: Add platform support for ufs host controller

 drivers/scsi/ufs/Kconfig        |   32 +++-
 drivers/scsi/ufs/Makefile       |    1 +
 drivers/scsi/ufs/ufs.h          |  103 +++++++++++
 drivers/scsi/ufs/ufshcd-pci.c   |  217 +++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-pltfm.c |  191 ++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c       |  374 ++++++++++----------------------------
 6 files changed, 640 insertions(+), 278 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfm.c

-- 
1.7.4.1

