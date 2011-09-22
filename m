From: "Jack Wang" <jack_wang@usish.com>
Subject: [PATCH] pm8001: raise host can queue
Date: Thu, 22 Sep 2011 10:05:45 +0800
Message-ID: <CE155251DF87469DA8F1A8290EDCF361@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_006B_01CC790F.3205E820"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:54355 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab1IVCFW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Sep 2011 22:05:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, JBottomley@parallels.com
Cc: 'lindar_liu' <lindar_liu@usish.com>, crystal_yu@usish.com, john_gong@usish.com, mark_salyzyn@us.xyratex.com

This is a multi-part message in MIME format.

------=_NextPart_000_006B_01CC790F.3205E820
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi James,

Because Dan change device queue depth to 256, and as point by Mark this may
result in starvation, so I bump the host can queue value to 510.

Best regards!

Jack

>From 3647cde88d66760ca336ad127a5b1fdf5c1d28f7 Mon Sep 17 00:00:00 2001
From: Jack Wang <jack_wang@usish.com>
Date: Thu, 22 Sep 2011 09:50:54 +0800
Subject: [PATCH] bump host can queue to follow libsas queue depth change

Signed-off-by: Jack Wang <jack_wang@usish.com>
---
 pm8001_defs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/pm8001_defs.h b/pm8001_defs.h
index 944afad..704b492 100644
--- a/pm8001_defs.h
+++ b/pm8001_defs.h
@@ -68,7 +68,7 @@ enum port_type {
 #define	PM8001_MAX_CCB		 512	/* max ccbs supported */
 #define	PM8001_MAX_INB_NUM	 1
 #define	PM8001_MAX_OUTB_NUM	 1
-#define	PM8001_CAN_QUEUE	 128	/* SCSI Queue depth */
+#define	PM8001_CAN_QUEUE	 510	/* SCSI Queue depth */
 
 /* unchangeable hardware details */
 #define	PM8001_MAX_PHYS		 8	/* max. possible phys */
-- 
1.7.4.msysgit.0



------=_NextPart_000_006B_01CC790F.3205E820
Content-Type: application/octet-stream;
	name="0001-bump-host-can-queue-to-follow-libsas-queue-depth-cha.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-bump-host-can-queue-to-follow-libsas-queue-depth-cha.patch"

>From 3647cde88d66760ca336ad127a5b1fdf5c1d28f7 Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Thu, 22 Sep 2011 09:50:54 +0800=0A=
Subject: [PATCH] bump host can queue to follow libsas queue depth change=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
---=0A=
 pm8001_defs.h |    2 +-=0A=
 1 files changed, 1 insertions(+), 1 deletions(-)=0A=
=0A=
diff --git a/pm8001_defs.h b/pm8001_defs.h=0A=
index 944afad..704b492 100644=0A=
--- a/pm8001_defs.h=0A=
+++ b/pm8001_defs.h=0A=
@@ -68,7 +68,7 @@ enum port_type {=0A=
 #define	PM8001_MAX_CCB		 512	/* max ccbs supported */=0A=
 #define	PM8001_MAX_INB_NUM	 1=0A=
 #define	PM8001_MAX_OUTB_NUM	 1=0A=
-#define	PM8001_CAN_QUEUE	 128	/* SCSI Queue depth */=0A=
+#define	PM8001_CAN_QUEUE	 510	/* SCSI Queue depth */=0A=
 =0A=
 /* unchangeable hardware details */=0A=
 #define	PM8001_MAX_PHYS		 8	/* max. possible phys */=0A=
-- =0A=
1.7.4.msysgit.0=0A=
=0A=

------=_NextPart_000_006B_01CC790F.3205E820--

