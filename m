From: Karl Magnus Kolstoe <Karl.Kolsto@uib.no>
Subject: [PATCH] 2.4.31; add Pioneer DRM-624x to drivers/scsi/scsi_scan.c
Date: Mon, 10 Oct 2005 10:51:14 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0510101021450.29207@drazi.geo.uib.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from noralf.uib.no ([129.177.30.12]:18389 "EHLO noralf.uib.no")
	by vger.kernel.org with ESMTP id S1750743AbVJJIvL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Oct 2005 04:51:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: karl.kolsto@uib.no



Hi,

The patch below made my Pioneer DRM-624X automatically
be set up with all 6 "drives". (6 slot SCSI CD changer)
(My DRM-604X already worked this way already.)

Please CC me on replies on this message since I am not on the
mailing list.

Signed-off-by: Karl Magnus Kolst=F8 <karl.kolsto@uib.no>

--=20
Karl Magnus Kolst=F8 - Member of the first RFC 1149 implementation team=
=2E


--- linux-2.4.31/drivers/scsi/scsi_scan.c.orig  2005-10-10 10:20:29.000=
000000 +0200
+++ linux-2.4.31/drivers/scsi/scsi_scan.c       2005-10-10 10:20:42.000=
000000 +0200
@@ -145,6 +145,7 @@ static struct dev_info device_list[] =3D
         {"PIONEER", "CD-ROM DRM-600", "*", BLIST_FORCELUN | BLIST_SING=
LELUN},
         {"PIONEER", "CD-ROM DRM-602X", "*", BLIST_FORCELUN | BLIST_SIN=
GLELUN},
         {"PIONEER", "CD-ROM DRM-604X", "*", BLIST_FORCELUN | BLIST_SIN=
GLELUN},
+       {"PIONEER", "CD-ROM DRM-624X", "*", BLIST_FORCELUN | BLIST_SING=
LELUN},
         {"EMULEX", "MD21/S2     ESDI", "*", BLIST_SINGLELUN},
         {"CANON", "IPUBJD", "*", BLIST_SPARSELUN},
         {"nCipher", "Fastness Crypto", "*", BLIST_FORCELUN},

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
