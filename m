From: "jack wang" <jack_wang@usish.com>
Subject: [RFC][PATCH 1/5] Add pm8001 SAS/SATA HBA driver to scsi Makefile
Date: Wed, 1 Jul 2009 20:33:29 +0800
Message-ID: <ECAC2B6071A14978B3CCF17A491EB241@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0003_01C9FA8B.32E61F30"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from usish.com ([210.5.144.203]:48584 "EHLO sr-smtp.usish.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbZGAMda (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jul 2009 08:33:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, lindar_liu@usish.com, aoqingyun@usish.com, tom_peng@usish.com, jack_wang@usish.com

This is a multi-part message in MIME format.

------=_NextPart_000_0003_01C9FA8B.32E61F30
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

>From b031ca9e1fc4b1c758bc4afb48fbf06dd251fb23 Mon Sep 17 00:00:00 2001
From: Jack Wang <jack_wang@usish.com>
Date: Wed, 1 Jul 2009 18:48:02 +0800
Subject: [PATCH 1/5] Add pm8001 SAS/SATA HBA driver to scsi Makefile

Signed-off-by: Jack Wang <jack_wang@usish.com>
Signed-off-by: Lindar Liu <lindar_liu@usish.com>
Signed-off-by: Tom Peng <tom_peng@usish.com>
---
 drivers/scsi/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 25429ea..5945917 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_SCSI_AIC79XX)	+= aic7xxx/
 obj-$(CONFIG_SCSI_AACRAID)	+= aacraid/
 obj-$(CONFIG_SCSI_AIC7XXX_OLD)	+= aic7xxx_old.o
 obj-$(CONFIG_SCSI_AIC94XX)	+= aic94xx/
+obj-$(CONFIG_SCSI_PM8001)	+= pm8001/
 obj-$(CONFIG_SCSI_IPS)		+= ips.o
 obj-$(CONFIG_SCSI_FD_MCS)	+= fd_mcs.o
 obj-$(CONFIG_SCSI_FUTURE_DOMAIN)+= fdomain.o
-- 


------=_NextPart_000_0003_01C9FA8B.32E61F30
Content-Type: application/octet-stream;
	name="0001-Add-pm8001-SAS-SATA-HBA-driver-to-scsi-Makefile.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-Add-pm8001-SAS-SATA-HBA-driver-to-scsi-Makefile.patch"

>From b031ca9e1fc4b1c758bc4afb48fbf06dd251fb23 Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Wed, 1 Jul 2009 18:48:02 +0800=0A=
Subject: [PATCH 1/5] Add pm8001 SAS/SATA HBA driver to scsi Makefile=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
Signed-off-by: Lindar Liu <lindar_liu@usish.com>=0A=
Signed-off-by: Tom Peng <tom_peng@usish.com>=0A=
---=0A=
 drivers/scsi/Makefile |    1 +=0A=
 1 files changed, 1 insertions(+), 0 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile=0A=
index 25429ea..5945917 100644=0A=
--- a/drivers/scsi/Makefile=0A=
+++ b/drivers/scsi/Makefile=0A=
@@ -70,6 +70,7 @@ obj-$(CONFIG_SCSI_AIC79XX)	+=3D aic7xxx/=0A=
 obj-$(CONFIG_SCSI_AACRAID)	+=3D aacraid/=0A=
 obj-$(CONFIG_SCSI_AIC7XXX_OLD)	+=3D aic7xxx_old.o=0A=
 obj-$(CONFIG_SCSI_AIC94XX)	+=3D aic94xx/=0A=
+obj-$(CONFIG_SCSI_PM8001)	+=3D pm8001/=0A=
 obj-$(CONFIG_SCSI_IPS)		+=3D ips.o=0A=
 obj-$(CONFIG_SCSI_FD_MCS)	+=3D fd_mcs.o=0A=
 obj-$(CONFIG_SCSI_FUTURE_DOMAIN)+=3D fdomain.o=0A=
-- =0A=
=0A=
=0A=

------=_NextPart_000_0003_01C9FA8B.32E61F30--

