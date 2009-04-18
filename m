From: Zhenwen Xu <helight.xu@gmail.com>
Subject: [PATCH]fix a warning on drivers/scsi/NCR_D700.c
Date: Sat, 18 Apr 2009 18:36:42 +0800
Message-ID: <20090418103642.GA4432@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:36656 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbZDRKiP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Apr 2009 06:38:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

fix this warning:

drivers/scsi/NCR_D700.c: In function =E2=80=98NCR_D700_probe=E2=80=99:
drivers/scsi/NCR_D700.c:322: warning: passing argument 2 of =E2=80=98re=
quest_irq=E2=80=99 from incompatible pointer type
drivers/scsi/NCR_D700.c:322: warning: passing argument 2 of =E2=80=98re=
quest_irq=E2=80=99 from incompatible pointer type
drivers/scsi/NCR_D700.c:322: warning: passing argument 2 of =E2=80=98re=
quest_irq=E2=80=99 from incompatible pointer type


Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 drivers/scsi/NCR_D700.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
index c889d84..1cdf09a 100644
--- a/drivers/scsi/NCR_D700.c
+++ b/drivers/scsi/NCR_D700.c
@@ -224,7 +224,7 @@ NCR_D700_probe_one(struct NCR_D700_private *p, int =
siop, int irq,
 	return ret;
 }
=20
-static int
+static irqreturn_t
 NCR_D700_intr(int irq, void *data)
 {
 	struct NCR_D700_private *p =3D (struct NCR_D700_private *)data;
--=20
1.5.6.5

--=20
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
