From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 09/55] scsi: Mark function as static in bfa/bfa_fcpim.c
Date: Sat, 29 Mar 2014 23:21:47 +0530
Message-ID: <532084c0161f21d192133e9523a7c1b6e4687e11.1396114897.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34568 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaC2RvW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Mar 2014 13:51:22 -0400
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org

Mark functions as static in bfa/bfa_fcpim.c because they are not used
outside this file.

This eliminates the following warning in bfa/bfa_fcpim.c:
drivers/scsi/bfa/bfa_fcpim.c:448:1: warning: no previous prototype for =
=E2=80=98bfa_ioim_profile_comp=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/bfa/bfa_fcpim.c:465:1: warning: no previous prototype for =
=E2=80=98bfa_ioim_profile_start=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bfa/bfa_fcpim.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.=
c
index d7385d1..604b4be 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -444,7 +444,7 @@ bfa_fcpim_port_iostats(struct bfa_s *bfa,
 	return BFA_STATUS_OK;
 }
=20
-void
+static void
 bfa_ioim_profile_comp(struct bfa_ioim_s *ioim)
 {
 	struct bfa_itnim_latency_s *io_lat =3D
@@ -461,7 +461,7 @@ bfa_ioim_profile_comp(struct bfa_ioim_s *ioim)
 	io_lat->avg[idx] +=3D val;
 }
=20
-void
+static void
 bfa_ioim_profile_start(struct bfa_ioim_s *ioim)
 {
 	ioim->start_time =3D jiffies;
--=20
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
