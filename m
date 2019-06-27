From: Avri Altman <Avri.Altman@wdc.com>
Subject: Re: [PATCH] scsi: uapi: ufs: Fix SPDX license identifier
Date: Thu, 27 Jun 2019 05:38:30 +0000
Message-ID: <SN6PR04MB4925E2C49630065F5201A7F5FCFD0@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1560346477-13944-1-git-send-email-avri.altman@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1560346477-13944-1-git-send-email-avri.altman@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Pedro Sousa <pedrom.sousa@synopsys.com>, Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avi Shchislowski <Avi.Shchislowski@wdc.com>, Alex Lemberg <Alex.Lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org

A gentle ping.

Thanks,
Avri



________________________________________
From: Avri Altman <avri.altman@wdc.com>
Sent: Wednesday, June 12, 2019 4:34:37 PM
To: James E.J. Bottomley; Martin K. Petersen; linux-scsi@vger.kernel.org; l=
inux-kernel@vger.kernel.org; Arnd Bergmann; Pedro Sousa; Alim Akhtar
Cc: Avi Shchislowski; Alex Lemberg; Avri Altman
Subject: [PATCH] scsi: uapi: ufs: Fix SPDX license identifier

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

diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_=
ufs.h
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
