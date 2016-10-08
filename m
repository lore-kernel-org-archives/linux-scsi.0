From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND PATCH v2 0/10] Support for Exynos specific UFS driver
Date: Sat, 08 Oct 2016 12:18:44 +0900
Message-ID: <000101d22112$ad503b10$07f0b130$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49510 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757504AbcJHDTB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2016 23:19:01 -0400
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OEP018M9L78EV40@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Sat, 08 Oct 2016 12:18:45 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, =?utf-8?B?7LaU7ZeM6rSR?= <hg.chu@samsung.com>

This series of patches introduce support for Exynos specific UFS driver.
An original version of this has been applied on mass production of commercial mobile devices.

I checked compiling with Subhash's patch
- [PATCH v3] scsi: ufshcd: fix possible unclocked register access

---
Changes from v1:
* Separate a set of newer callbacks to be added
* Make Exynos specific UFS driver compatible with a following patch
     [PATCH v3] scsi: ufshcd: fix possible unclocked register access
     (http://www.spinics.net/lists/linux-scsi/msg100290.html)
* Rename three of the callbacks as follows:
   set_nexus_t_xfer_req -> setup_xfer_req
   set_nexus_t_task_mgmt -> setup_task_mgmt
   hibern8_notify -> setup_hibern8
---
 Documentation/devicetree/bindings/ufs/ufs-exynos.txt |   93 +
 drivers/scsi/ufs/Kconfig                                       |   10 +
 drivers/scsi/ufs/Makefile                                     |    1 +
 drivers/scsi/ufs/mphy.h                                        |   38 +
 drivers/scsi/ufs/ufs-exynos.c                                | 2099 ++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos.h                                |  621 ++++++
 drivers/scsi/ufs/ufshcd.c                                     |  144 +-
 drivers/scsi/ufs/ufshcd.h                                     |   55 +
 drivers/scsi/ufs/ufshci.h                                     |   14 +-
 drivers/scsi/ufs/unipro.h                                     |   24 +
 10 files changed, 3079 insertions(+), 20 deletions(-)  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt
 create mode 100644 drivers/scsi/ufs/mphy.h  create mode 100644 drivers/scsi/ufs/ufs-exynos.c  create mode 100644 drivers/scsi/ufs/ufs-exynos.h

--
1.7.9.5

--

