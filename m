From: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
Subject: [PATCH 1/1] [SCSI] scsi_debug: add missing csum var initialization
Date: Fri, 13 Sep 2013 14:21:17 -0300
Message-ID: <1379092877-5173-1-git-send-email-antonio.alecrim@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f48.google.com ([209.85.213.48]:32882 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab3IMUVG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 16:21:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Antonio Alecrim Jr <antonio.alecrim@gmail.com>

Removes the warning:
include/uapi/linux/swab.h:106:23: warning: =E2=80=98csum=E2=80=99 may b=
e used
uninitialized in this function

Signed-off-by: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 01c0ffa..f149747 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1733,7 +1733,7 @@ static int do_device_access(struct scsi_cmnd *scm=
d,
=20
 static u16 dif_compute_csum(const void *buf, int len)
 {
-	u16 csum;
+	u16 csum =3D 0;
=20
 	switch (scsi_debug_guard) {
 	case 1:
--=20
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
