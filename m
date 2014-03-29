From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 39/55] scsi: Mark functions as static in qla2xxx/qla_iocb.c
Date: Sat, 29 Mar 2014 23:58:28 +0530
Message-ID: <52c3b0cf7c2d793945554277be595fa2ea88b984.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40258 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaC2S2D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Mar 2014 14:28:03 -0400
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org

Mark functions as static in qla2xxx/qla_iocb.c because they are not use=
d
outside this file.

This eliminates the following warning in qla2xxx/qla_iocb.c:
drivers/scsi/qla2xxx/qla_iocb.c:714:1: warning: no previous prototype f=
or =E2=80=98qla24xx_calc_dsd_lists=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/qla2xxx/qla_iocb.c:734:1: warning: no previous prototype f=
or =E2=80=98qla24xx_build_scsi_iocbs=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla=
_iocb.c
index 46b9307..2629477 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -710,7 +710,7 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct c=
md_type_6 *cmd_pkt,
  *
  * Returns the number of dsd list needed to store @dsds.
  */
-inline uint16_t
+static inline uint16_t
 qla24xx_calc_dsd_lists(uint16_t dsds)
 {
 	uint16_t dsd_lists =3D 0;
@@ -730,7 +730,7 @@ qla24xx_calc_dsd_lists(uint16_t dsds)
  * @cmd_pkt: Command type 3 IOCB
  * @tot_dsds: Total number of segments to transfer
  */
-inline void
+static inline void
 qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
     uint16_t tot_dsds)
 {
--=20
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
