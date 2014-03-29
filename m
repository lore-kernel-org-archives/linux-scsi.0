From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 45/55] scsi: Mark funtion as static in hpsa.c
Date: Sun, 30 Mar 2014 00:09:56 +0530
Message-ID: <43d1f6881b0323ae26b126b5b31b4884aa8f6b0f.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60710 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaC2Sja (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Mar 2014 14:39:30 -0400
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, josh@joshtriplett.org

Mark function as static in hpsa.c because it is not used outside this
file.

This eliminates the following warning in hpsa.c:
drivers/scsi/hpsa.c:1925:5: warning: no previous prototype for =E2=80=98=
figure_lunaddrbytes=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/hpsa.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 868318a..025dc8e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1922,8 +1922,9 @@ static int hpsa_gather_lun_info(struct ctlr_info =
*h,
 	return 0;
 }
=20
-u8 *figure_lunaddrbytes(struct ctlr_info *h, int raid_ctlr_position, i=
nt i,
-	int nphysicals, int nlogicals, struct ReportLUNdata *physdev_list,
+static u8 *figure_lunaddrbytes(struct ctlr_info *h, int raid_ctlr_posi=
tion,
+	int i, int nphysicals, int nlogicals,
+	struct ReportLUNdata *physdev_list,
 	struct ReportLUNdata *logdev_list)
 {
 	/* Helper function, figure out where the LUN ID info is coming from
--=20
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
