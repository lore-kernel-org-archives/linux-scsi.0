From: Girish K S <girish.shivananjappa@linaro.org>
Subject: [RFC V3 0/2] Add support for pci/non-pci probing for UFS
Date: Mon, 21 May 2012 12:01:06 +0530
Message-ID: <1337581868-3042-1-git-send-email-girish.shivananjappa@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36111 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab2EUGbY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2012 02:31:24 -0400
Received: by dady13 with SMTP id y13so6384048dad.19
        for <linux-scsi@vger.kernel.org>; Sun, 20 May 2012 23:31:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, hch@infradead.org, patches@linaro.org, svenkatr@ti.com, Girish K S <girish.shivananjappa@linaro.org>

The existing UFS driver is tightly bound to only pci specific devices.
It cannot work for non-pci devices.

"SCSI: UFS: Create separate UFS core and pci modules" patch splits the
ufs driver into core driver and pci probe driver.

"SCSI: UFS: Add platform support for ufs host controller" patch adds
support for the platform probing for non-pci devices

changes in v3:
		-Modified the ufshcd.c ufshcd-pci.c ufshcd0pltfm.c to follow the
driver module initialization standard. suggested by venkatraman.

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
 drivers/scsi/ufs/Makefile       |    2 +
 drivers/scsi/ufs/ufs.h          |  103 +++++++++++
 drivers/scsi/ufs/ufshcd-pci.c   |  206 ++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-pltfm.c |  180 +++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c       |  370 ++++++++++-----------------------------
 6 files changed, 615 insertions(+), 278 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfm.c

-- 
1.7.4.1

