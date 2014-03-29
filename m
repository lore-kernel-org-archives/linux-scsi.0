From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 38/55] scsi: Mark function as static in qla2xxx/qla_bsg.c
Date: Sat, 29 Mar 2014 23:57:14 +0530
Message-ID: <c3a16784d115b3af27a8415a00add57041e9cda5.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark function as static in qla2xxx/qla_bsg.c because it is not used
outside this file.

This eliminates the following warning in qla2xxx/qla_bsg.c:
drivers/scsi/qla2xxx/qla_bsg.c:409:1: warning: no previous prototype fo=
r =E2=80=98qla24xx_calc_ct_iocbs=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_=
bsg.c
index f15d03e..16b7e58 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -405,7 +405,7 @@ done:
 	return rval;
 }
=20
-inline uint16_t
+static inline uint16_t
 qla24xx_calc_ct_iocbs(uint16_t dsds)
 {
 	uint16_t iocbs;
--=20
1.7.9.5
