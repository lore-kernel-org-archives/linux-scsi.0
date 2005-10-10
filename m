From: Karl Magnus Kolstoe <Karl.Kolsto@uib.no>
Subject: [PATCH] 2.6.13.3; add Pioneer DRM-624x to drivers/scsi/scsi_devinfo.c
Date: Mon, 10 Oct 2005 10:59:52 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0510101056090.29207@drazi.geo.uib.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from noralf.uib.no ([129.177.30.12]:14301 "EHLO noralf.uib.no")
	by vger.kernel.org with ESMTP id S1750734AbVJJI7r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Oct 2005 04:59:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: karl.kolsto@uib.no


Hi,

The patch below should make the Pioneer DRM-624X automatically
be set up with all 6 "drives". (6 slot SCSI CD changer)

I have not tested this patch on a 2.6-kernel, but the equivalent
2.4-patch seems to work perfectly. (See other mail.)

Please CC me on replies on this message since I am not on the
mailing list.

Signed-off-by: Karl Magnus Kolst=F8 <karl.kolsto@uib.no>

--=20
Karl Magnus Kolst=F8 - Member of the first RFC 1149 implementation team=
=2E


--- linux-2.6.13.3/drivers/scsi/scsi_devinfo.c.orig     2005-10-10 10:1=
7:34.000000000 +0200
+++ linux-2.6.13.3/drivers/scsi/scsi_devinfo.c  2005-10-10 10:17:53.000=
000000 +0200
@@ -183,6 +183,7 @@ static struct {
         {"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN | BLIST_SIN=
GLELUN},
         {"PIONEER", "CD-ROM DRM-602X", NULL, BLIST_FORCELUN | BLIST_SI=
NGLELUN},
         {"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SI=
NGLELUN},
+       {"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SIN=
GLELUN},
         {"REGAL", "CDC-4X", NULL, BLIST_MAX5LUN | BLIST_SINGLELUN},
         {"SanDisk", "ImageMate CF-SD1", NULL, BLIST_FORCELUN},
         {"SEAGATE", "ST34555N", "0930", BLIST_NOTQ},    /* Chokes on t=
agged INQUIRY */

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
