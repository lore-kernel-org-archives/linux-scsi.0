From: Karl Magnus Kolstoe <Karl.Kolsto@uib.no>
Subject: [resend, unmangle] [PATCH] 2.4.31; add Pioneer DRM-624x to drivers/scsi/scsi_scan.c
Date: Mon, 17 Oct 2005 10:07:51 +0200
Message-ID: <E1ERQ2B-00057L-Nz@alf.uib.no.invalid>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alf.uib.no ([129.177.30.3]:12173 "EHLO alf.uib.no")
	by vger.kernel.org with ESMTP id S932130AbVJQIHw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 04:07:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com


Resending, hopefully with unbroken patch this time.

>Hi,
>
>The patch below made my Pioneer DRM-624X automatically
>be set up with all 6 "drives". (6 slot SCSI CD changer)
>(My DRM-604X already worked this way already.)
>
>Please CC me on replies on this message since I am not on the
>mailing list.

--=20
Karl Magnus Kolst=F8 - Member of the first RFC 1149 implementation team=
=2E


Signed-off-by: Karl Magnus Kolst=F8 <karl.kolsto@uib.no>


--- linux-2.4.31/drivers/scsi/scsi_scan.c.orig	2005-10-16 19:57:36.0000=
00000 +0200
+++ linux-2.4.31/drivers/scsi/scsi_scan.c	2005-10-16 19:57:57.000000000=
 +0200
@@ -145,6 +145,7 @@ static struct dev_info device_list[] =3D
 	{"PIONEER", "CD-ROM DRM-600", "*", BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-602X", "*", BLIST_FORCELUN | BLIST_SINGLELUN}=
,
 	{"PIONEER", "CD-ROM DRM-604X", "*", BLIST_FORCELUN | BLIST_SINGLELUN}=
,
+	{"PIONEER", "CD-ROM DRM-624X", "*", BLIST_FORCELUN | BLIST_SINGLELUN}=
,
 	{"EMULEX", "MD21/S2     ESDI", "*", BLIST_SINGLELUN},
 	{"CANON", "IPUBJD", "*", BLIST_SPARSELUN},
 	{"nCipher", "Fastness Crypto", "*", BLIST_FORCELUN},
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
