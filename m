From: "jack wang" <jack_wang@usish.com>
Subject: [PATCH 6/9] pm8001:bit set pm8001_ha->flags
Date: Mon, 7 Dec 2009 17:22:59 +0800
Message-ID: <804297FD5BE0487C810E2C0C6E62EFD9@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0026_01CA7761.ECB0E730"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:53061 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759302AbZLGJW7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2009 04:22:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>, 'jack wang' <jack_wang@usish.com>

This is a multi-part message in MIME format.

------=_NextPart_000_0026_01CA7761.ECB0E730
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit


Signed-off-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_sas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c
b/drivers/scsi/pm8001/pm8001_sas.c
index 487f78f..c86f921 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -656,7 +656,7 @@ static int pm8001_dev_found_notify(struct domain_device
*dev)
 	wait_for_completion(&completion);
 	if (dev->dev_type == SAS_END_DEV)
 		msleep(50);
-	pm8001_ha->flags = PM8001F_RUN_TIME ;
+	pm8001_ha->flags |= PM8001F_RUN_TIME ;
 	return 0;
 found_out:
 	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-- 
1.6.5.1.1367.gcd48


------=_NextPart_000_0026_01CA7761.ECB0E730
Content-Type: application/octet-stream;
	name="0006-bit-set-for-hba-flags.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0006-bit-set-for-hba-flags.patch"

>From 1c048fed463455116bb0ff0f55e4d11cb867825d Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Mon, 7 Dec 2009 15:48:03 +0800=0A=
Subject: [PATCH 6/9] bit set for hba flags=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
---=0A=
 drivers/scsi/pm8001/pm8001_sas.c |    2 +-=0A=
 1 files changed, 1 insertions(+), 1 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/pm8001/pm8001_sas.c =
b/drivers/scsi/pm8001/pm8001_sas.c=0A=
index 487f78f..c86f921 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_sas.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_sas.c=0A=
@@ -656,7 +656,7 @@ static int pm8001_dev_found_notify(struct =
domain_device *dev)=0A=
 	wait_for_completion(&completion);=0A=
 	if (dev->dev_type =3D=3D SAS_END_DEV)=0A=
 		msleep(50);=0A=
-	pm8001_ha->flags =3D PM8001F_RUN_TIME ;=0A=
+	pm8001_ha->flags |=3D PM8001F_RUN_TIME ;=0A=
 	return 0;=0A=
 found_out:=0A=
 	spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
-- =0A=
1.6.5.1.1367.gcd48=0A=
=0A=

------=_NextPart_000_0026_01CA7761.ECB0E730--

