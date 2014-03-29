From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 40/55] scsi: Mark function as static in qla2xxx/qla_nx.c
Date: Sat, 29 Mar 2014 23:59:27 +0530
Message-ID: <9d5974b237aa399b5d979609904c6b212206831f.1396114898.git.rashika.kheria@gmail.com>
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

Mark function as static in qla2xxx/qla_nx.c because it is not used
outside this file.

This eliminates the following warning in qla2xxx/qla_nx.c:
drivers/scsi/qla2xxx/qla_nx.c:2292:1: warning: no previous prototype fo=
r =E2=80=98qla82xx_set_idc_version=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/qla2xxx/qla_nx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_n=
x.c
index 1e6ba4a..cf49b39 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2288,7 +2288,7 @@ void qla82xx_init_flags(struct qla_hw_data *ha)
 	ha->nx_legacy_intr.pci_int_reg =3D nx_legacy_intr->pci_int_reg;
 }
=20
-inline void
+static inline void
 qla82xx_set_idc_version(scsi_qla_host_t *vha)
 {
 	int idc_ver;
--=20
1.7.9.5
