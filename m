From: Girish K S <girish.shivananjappa@linaro.org>
Subject: [RFC RESEND 0/4] Add support for pci/non-pci probing for UFS
Date: Tue, 15 May 2012 15:06:23 +0530
Message-ID: <1337074587-29021-1-git-send-email-girish.shivananjappa@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55186 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab2EOJgu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2012 05:36:50 -0400
Received: by pbbrp8 with SMTP id rp8so7292170pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 May 2012 02:36:50 -0700 (PDT)
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
 drivers/scsi/ufs/ufshcd-pci.c   |  218 ++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-pltfm.c |  191 ++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c       |  377 +++++++++------------------------------
 6 files changed, 624 insertions(+), 299 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfm.c

-- 
1.7.4.1

