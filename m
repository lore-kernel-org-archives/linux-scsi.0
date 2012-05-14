From: Girish K S <girish.shivananjappa@linaro.org>
Subject: [RFC PATCH 0/4] Add support for pci/non-pci probing for UFS
Date: Mon, 14 May 2012 16:38:28 +0530
Message-ID: <1336993712-9111-1-git-send-email-girish.shivananjappa@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55965 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab2ENLIt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2012 07:08:49 -0400
Received: by dady13 with SMTP id y13so5778511dad.19
        for <linux-scsi@vger.kernel.org>; Mon, 14 May 2012 04:08:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, patches@linaro.org, Girish K S <girish.shivananjappa@linaro.org>

The existing UFS driver is tightly bound to only pci specific devices.
It cannot work for non-pci devices.

"SCSI: UFS: remove all pci code from core driver" patch removes all the
pci specific code from the core driver to make it generic

"SCSI: UFS: Add support for pci probe" patch adds a new file to support
pci probing.

"SCSI: UFS: Add platform support for ufs host controller" patch adds a new
file to support platform device probe

"SCSI: UFS: Added support of PCI/PLTFM for UFS" patch adds the menu option
in Kconfig and Makefile to enable/disable the specific option 

Girish K S (4):
  SCSI: UFS: remove all pci code from core driver
  SCSI: UFS: Add support for pci probe
  SCSI: UFS: Add platform support for ufs host controller
  SCSI: UFS: Added support of PCI/PLTFM for UFS

 drivers/scsi/ufs/Kconfig        |   32 +++-
 drivers/scsi/ufs/Makefile       |    2 +
 drivers/scsi/ufs/ufs.h          |  103 +++++++++++
 drivers/scsi/ufs/ufshcd-pci.c   |  217 ++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-pltfm.c |  191 ++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c       |  377 +++++++++------------------------------
 6 files changed, 623 insertions(+), 299 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfm.c

-- 
1.7.4.1

