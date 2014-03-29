From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 06/55] scsi: Mark function as static in bfa/bfa_ioc_ct.c
Date: Sat, 29 Mar 2014 23:18:22 +0530
Message-ID: <6f86afec846c5d45f4c30c0fae98f8bd1258859c.1396114897.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:48814 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaC2Rr7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Mar 2014 13:47:59 -0400
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org

Mark functions as static in bfa/bfa_ioc_ct.c because they are not
used outside this file.

This eliminates the following warnings in bfa/bfa_ioc_ct.c:
drivers/scsi/bfa/bfa_ioc_ct.c:375:1: warning: no previous prototype for=
 =E2=80=98bfa_ioc_ct2_lpu_read_stat=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/bfa/bfa_ioc_ct.c:755:1: warning: no previous prototype for=
 =E2=80=98bfa_ioc_ct2_mac_reset=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bfa/bfa_ioc_ct.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_c=
t.c
index bd53150..746c250 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -371,7 +371,7 @@ bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_=
boolean_t msix)
 	writel(r32, rb + FNC_PERS_REG);
 }
=20
-bfa_boolean_t
+static bfa_boolean_t
 bfa_ioc_ct2_lpu_read_stat(struct bfa_ioc_s *ioc)
 {
 	u32	r32;
@@ -751,7 +751,7 @@ bfa_ioc_ct2_mem_init(void __iomem *rb)
 	writel(0, (rb + CT2_MBIST_CTL_REG));
 }
=20
-void
+static void
 bfa_ioc_ct2_mac_reset(void __iomem *rb)
 {
 	/* put port0, port1 MAC & AHB in reset */
--=20
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
