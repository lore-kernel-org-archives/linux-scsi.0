From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1 0/8] Support for Exynos specific UFS driver
Date: Thu, 06 Oct 2016 17:12:54 +0900
Message-ID: <006301d21fa9$70aebe80$520c3b80$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:42868 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754019AbcJFIWz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2016 04:22:55 -0400
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OEM020CM9H94C50@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 06 Oct 2016 17:12:54 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: =?UTF-8?B?7LaU7ZeM6rSR?= <hg.chu@samsung.com>

This series of patches introduce support for Exynos specific UFS driver.
An original version of this has been applied on mass production
of commercial mobile devices.

 Documentation/devicetree/bindings/ufs/ufs-exynos.txt |   93 +
 drivers/scsi/ufs/Kconfig                                      |   10 +
 drivers/scsi/ufs/Makefile                                     |    1 +
 drivers/scsi/ufs/mphy.h                                        |   38 +
 drivers/scsi/ufs/ufs-exynos.c                                | 2084 ++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos.h                                |  621 ++++++
 drivers/scsi/ufs/ufshcd.c                                     |  146 +-
 drivers/scsi/ufs/ufshcd.h                                     |   62 +
 drivers/scsi/ufs/ufshci.h                                     |   14 +-
 drivers/scsi/ufs/unipro.h                                     |   24 +
 10 files changed, 3073 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt
 create mode 100644 drivers/scsi/ufs/mphy.h
 create mode 100644 drivers/scsi/ufs/ufs-exynos.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos.h

-- 
1.7.9.5

