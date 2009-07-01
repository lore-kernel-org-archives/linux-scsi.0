From: "jack wang" <jack_wang@usish.com>
Subject: [RFC][PATCH 2/5] Add pm8001 SAS/SATA HBA driver to scsi Kconfig
Date: Wed, 1 Jul 2009 20:35:28 +0800
Message-ID: <F7CD545430B94E1883D4AA9FAE159B9A@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0009_01C9FA8B.78C2F2D0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from usish.com ([210.5.144.203]:48605 "EHLO sr-smtp.usish.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbZGAMf0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jul 2009 08:35:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, lindar_liu@usish.com, aoqingyun@usish.com, tom_peng@usish.com, jack_wang@usish.com

This is a multi-part message in MIME format.

------=_NextPart_000_0009_01C9FA8B.78C2F2D0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

>From 9bb30481d2f2c0153516e6c9b9396bd8b0c64f1a Mon Sep 17 00:00:00 2001
From: Jack Wang <jack_wang@usish.com>
Date: Wed, 1 Jul 2009 18:57:11 +0800
Subject: [PATCH 2/5] Add pm8001 SAS/SATA HBA driver to scsi Kconfig

Signed-off-by: Jack Wang <jack_wang@usish.com>
Signed-off-by: Lindar Liu <lindar_liu@usish.com>
Signed-off-by: Tom Peng <tom_peng@usish.com>
---
 drivers/scsi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9c23122..0fd285f 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -520,7 +520,7 @@ config SCSI_AIC7XXX_OLD
 source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
 source "drivers/scsi/aic94xx/Kconfig"
 source "drivers/scsi/mvsas/Kconfig"
-
+source "drivers/scsi/pm8001/Kconfig"
 config SCSI_DPT_I2O
 	tristate "Adaptec I2O RAID support "
 	depends on SCSI && PCI && VIRT_TO_BUS
-- 


------=_NextPart_000_0009_01C9FA8B.78C2F2D0
Content-Type: application/octet-stream;
	name="0002-Add-pm8001-SAS-SATA-HBA-driver-to-scsi-Kconfig.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0002-Add-pm8001-SAS-SATA-HBA-driver-to-scsi-Kconfig.patch"

>From 9bb30481d2f2c0153516e6c9b9396bd8b0c64f1a Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Wed, 1 Jul 2009 18:57:11 +0800=0A=
Subject: [PATCH 2/5] Add pm8001 SAS/SATA HBA driver to scsi Kconfig=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
Signed-off-by: Lindar Liu <lindar_liu@usish.com>=0A=
Signed-off-by: Tom Peng <tom_peng@usish.com>=0A=
---=0A=
 drivers/scsi/Kconfig |    2 +-=0A=
 1 files changed, 1 insertions(+), 1 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig=0A=
index 9c23122..0fd285f 100644=0A=
--- a/drivers/scsi/Kconfig=0A=
+++ b/drivers/scsi/Kconfig=0A=
@@ -520,7 +520,7 @@ config SCSI_AIC7XXX_OLD=0A=
 source "drivers/scsi/aic7xxx/Kconfig.aic79xx"=0A=
 source "drivers/scsi/aic94xx/Kconfig"=0A=
 source "drivers/scsi/mvsas/Kconfig"=0A=
-=0A=
+source "drivers/scsi/pm8001/Kconfig"=0A=
 config SCSI_DPT_I2O=0A=
 	tristate "Adaptec I2O RAID support "=0A=
 	depends on SCSI && PCI && VIRT_TO_BUS=0A=
-- =0A=
=0A=
=0A=

------=_NextPart_000_0009_01C9FA8B.78C2F2D0--

