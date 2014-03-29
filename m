From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 42/55] scsi: Mark function as static in scsi_transport_fc.c
Date: Sun, 30 Mar 2014 00:02:51 +0530
Message-ID: <37fd6c59540600548392b82debb4513e858aebd1.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark function as static in scsi_transport_fc.c because it is not used
outside this file.

This eliminates the following warning in scsi_transport_fc.c:
drivers/scsi/scsi_transport_fc.c:2025:5: warning: no previous prototype=
 for =E2=80=98scsi_is_fc_vport=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/scsi_transport_fc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_trans=
port_fc.c
index 4628fd5..7c01007 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2022,11 +2022,10 @@ static void fc_vport_dev_release(struct device =
*dev)
 	kfree(vport);
 }
=20
-int scsi_is_fc_vport(const struct device *dev)
+static int scsi_is_fc_vport(const struct device *dev)
 {
 	return dev->release =3D=3D fc_vport_dev_release;
 }
-EXPORT_SYMBOL(scsi_is_fc_vport);
=20
 static int fc_vport_match(struct attribute_container *cont,
 			    struct device *dev)
--=20
1.7.9.5
