From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 03/55] drivers: scsi: Mark function as static in bfa/bfad.c
Date: Sat, 29 Mar 2014 23:14:40 +0530
Message-ID: <3bf8b0908b8de2e7919a74e395bddb399203c66a.1396114897.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39012 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaC2RoP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Mar 2014 13:44:15 -0400
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org

Mark function as static in bfa/bfad.c because it is not used outside
this file.

This eliminates the following warning in bfa/bfad.c:
drivers/scsi/bfa/bfad.c:1522:1: warning: no previous prototype for 'res=
tart_bfa=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bfa/bfad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index cc0fbcd..e7abf9f 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1518,7 +1518,7 @@ bfad_pci_error_detected(struct pci_dev *pdev, pci=
_channel_state_t state)
 	return ret;
 }
=20
-int
+static int
 restart_bfa(struct bfad_s *bfad)
 {
 	unsigned long flags;
--=20
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
