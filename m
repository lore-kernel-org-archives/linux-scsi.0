From: Jan Kotas <jank@cadence.com>
Subject: [PATCH 1/2] dt-bindings: scsi: ufs-cdns: Update Cadence UFS compatibility list
Date: Wed, 27 Mar 2019 14:44:04 +0000
Message-ID: <20190327144405.5716-2-jank@cadence.com>
References: <20190327144405.5716-1-jank@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327144405.5716-1-jank@cadence.com>
Sender: linux-kernel-owner@vger.kernel.org
To: robh+dt@kernel.org, mark.rutland@arm.com, alim.akhtar@samsung.com, avri.altman@wdc.com, pedrom.sousa@synopsys.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jan Kotas <jank@cadence.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds a new compatible string description for
CDNS UFS HCD + M31 16nm PHY.

Signed-off-by: Jan Kotas <jank@cadence.com>
---
 Documentation/devicetree/bindings/ufs/cdns,ufshc.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt b/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
index a04a4989e..02347b017 100644
--- a/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
+++ b/Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
@@ -5,8 +5,9 @@ Each UFS controller instance should have its own node.
 Please see the ufshcd-pltfrm.txt for a list of all available properties.
 
 Required properties:
-- compatible	: Compatible list, contains the following controller:
-			"cdns,ufshc"
+- compatible	: Compatible list, contains one of the following controllers:
+			"cdns,ufshc" - Generic CDNS HCI,
+			"cdns,ufshc-m31-16nm" - CDNS UFS HC + M31 16nm PHY
 		  complemented with the JEDEC version:
 			"jedec,ufs-2.0"
 
-- 
2.15.0
