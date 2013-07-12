From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: =?UTF-8?q?=5BPATCH=202/2=5D=20MAINTAINER=3A=20Added=20maintainer=20info=20for=20bnx2i?=
Date: Thu, 11 Jul 2013 17:15:56 -0700
Message-ID: <1373588156-14077-2-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
 <1373588156-14077-1-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2420 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab3GLAQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jul 2013 20:16:15 -0400
In-Reply-To: <1373588156-14077-1-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 50105f9..e297cb0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1816,6 +1816,12 @@ L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/bnx2fc/
=20
+BROADCOM BNX2I 1/10 GIGABIT iSCSI DRIVER
+M:	Eddie Wai <eddie.wai@broadcom.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/bnx2i/
+
 BROADCOM SPECIFIC AMBA DRIVER (BCMA)
 M:	Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
 L:	linux-wireless@vger.kernel.org
--=20
1.7.7.4


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
