From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 19/55] scsi: Mark function as static in isci/phy.c
Date: Sat, 29 Mar 2014 23:34:11 +0530
Message-ID: <aeac50e3686d8daafd573ebd08805b8a97d85ebd.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, Lukasz Dorau <lukasz.dorau@intel.com>, Maciej Patelczyk <maciej.patelczyk@intel.com>, Dave Jiang <dave.jiang@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark function as static in isci/phy.c because it is not used outside
this file.

This eliminates the following warning in isci/phy.c:
drivers/scsi/isci/phy.c:672:6: warning: no previous prototype for =E2=80=
=98scu_link_layer_set_txcomsas_timeout=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/isci/phy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index cb87b2e..8e21022 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -669,7 +669,8 @@ static const char *phy_event_name(u32 event_code)
 		phy_state_name(state), phy_event_name(code), code)
=20
=20
-void scu_link_layer_set_txcomsas_timeout(struct isci_phy *iphy, u32 ti=
meout)
+static void scu_link_layer_set_txcomsas_timeout(struct isci_phy *iphy,
+						u32 timeout)
 {
 	u32 val;
=20
--=20
1.7.9.5
