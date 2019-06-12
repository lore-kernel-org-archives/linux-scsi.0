From: Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: uapi: ufs: Fix SPDX license identifier
Date: Wed, 12 Jun 2019 16:34:37 +0300
Message-ID: <1560346477-13944-1-git-send-email-avri.altman@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Pedro Sousa <pedrom.sousa@synopsys.com>, Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avi Shchislowski <avi.shchislowski@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Avri Altman <avri.altman@wdc.com>
List-Id: linux-scsi@vger.kernel.org

added 'WITH Linux-syscall-note' exception, which is the officially
assigned exception identifier for the kernel syscall exception.
This exception makes it possible to include GPL headers into non GPL
code, without confusing license compliance tools.

fixes: a851b2bd3632 (scsi: uapi: ufs: Make utp_upiu_req visible to user
		     space)

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 include/uapi/scsi/scsi_bsg_ufs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
index 17c7abd..9988db6 100644
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
  * UFS Transport SGIO v4 BSG Message Support
  *
-- 
1.9.1
