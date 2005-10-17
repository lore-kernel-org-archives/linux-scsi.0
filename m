From: Karl Magnus Kolstoe <Karl.Kolsto@uib.no>
Subject: [resend] Re: [PATCH] 2.6.13.3; add Pioneer DRM-624x to drivers/scsi/scsi_devinfo.c
Date: Mon, 17 Oct 2005 10:05:42 +0200
Message-ID: <E1ERQ06-0004uO-5Q@alf.uib.no.invalid>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alf.uib.no ([129.177.30.3]:51851 "EHLO alf.uib.no")
	by vger.kernel.org with ESMTP id S932128AbVJQIFo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 04:05:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org


On Sun, 16 Oct 2005 12:08:08 -0500, James Bottomley wrote:
>On Mon, 2005-10-10 at 10:59 +0200, Karl Magnus Kolstoe wrote:
>
>> The patch below should make the Pioneer DRM-624X automatically
>> be set up with all 6 "drives". (6 slot SCSI CD changer)
>>
>> I have not tested this patch on a 2.6-kernel, but the equivalent
>> 2.4-patch seems to work perfectly. (See other mail.)
>
>This patch doesn't apply.  It looks like your mailer has converted tab=
s
>to spaces.

Sorry about that.
(I forgot how braindead pine can be)

I hope this one is in better condition, for 2.6.13.4 this time.

--=20
Karl Magnus


Signed-off-by: Karl Magnus Kolst=F8 <karl.kolsto@uib.no>


--- linux-2.6.13.4/drivers/scsi/scsi_devinfo.c.orig	2005-10-16 20:09:34=
=2E000000000 +0200
+++ linux-2.6.13.4/drivers/scsi/scsi_devinfo.c	2005-10-16 20:09:59.0000=
00000 +0200
@@ -183,6 +183,7 @@ static struct {
 	{"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN | BLIST_SINGLELUN}=
,
 	{"PIONEER", "CD-ROM DRM-602X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN=
},
 	{"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN=
},
+	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN=
},
 	{"REGAL", "CDC-4X", NULL, BLIST_MAX5LUN | BLIST_SINGLELUN},
 	{"SanDisk", "ImageMate CF-SD1", NULL, BLIST_FORCELUN},
 	{"SEAGATE", "ST34555N", "0930", BLIST_NOTQ},	/* Chokes on tagged INQU=
IRY */
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
