From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 43/55] scsi: Mark function as static in scsi_transport_iscsi.c
Date: Sun, 30 Mar 2014 00:05:56 +0530
Message-ID: <eef277e596edf0e016d18543fe1638148c775ff8.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, "James E.J. Bottomley" <JBottomley@parallels.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark function as static in scsi_transport_iscsi.c because it is not use=
d
outside this file. Also, unexport the function since it's only used in
this file.

This eliminates the following warning in scsi_transport_iscsi.c:
drivers/scsi/scsi_transport_iscsi.c:1325:5: warning: no previous protot=
ype for =E2=80=98iscsi_is_flashnode_conn_dev=E2=80=99 [-Wmissing-protot=
ypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/scsi_transport_iscsi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_tr=
ansport_iscsi.c
index fd8ffe6..5b6185e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1322,11 +1322,10 @@ EXPORT_SYMBOL_GPL(iscsi_create_flashnode_conn);
  *  1 on success
  *  0 on failure
  */
-int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
+static int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
 {
 	return dev->bus =3D=3D &iscsi_flashnode_bus;
 }
-EXPORT_SYMBOL_GPL(iscsi_is_flashnode_conn_dev);
=20
 static int iscsi_destroy_flashnode_conn(struct iscsi_bus_flash_conn *f=
node_conn)
 {
--=20
1.7.9.5
