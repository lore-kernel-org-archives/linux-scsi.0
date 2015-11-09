From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v5 01/11] Documentation: samsung-phy: Add dt bindings for UFS
Date: Mon, 09 Nov 2015 10:56:17 +0530
Message-ID: <1447046787-480-2-git-send-email-alim.akhtar@samsung.com>
References: <1447046787-480-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1447046787-480-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, gautam.vivek@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org, kishon@ti.com
List-Id: linux-scsi@vger.kernel.org

Adds exynos UFS PHY device tree bindings information.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 .../devicetree/bindings/phy/samsung-phy.txt        |   22 ++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index 0289d3b07853..565200d72e91 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -177,3 +177,25 @@ Example:
 		usbdrdphy0 = &usb3_phy0;
 		usbdrdphy1 = &usb3_phy1;
 	};
+
+Samsung Exynos7 soc series UFS PHY Controller
+---------------------------------------------
+
+UFS PHY nodes are defined to describe on-chip UFS Physical layer controllers.
+Each UFS PHY controller should have its own node.
+
+Required properties:
+- compatible        : compatible should be set to "samsung,exynos7-ufs-phy"
+- reg : offset and length of the UFS PHY register set
+- reg-names : reg name(s) must be 'phy-pma'
+- #phy-cells : must be zero
+- samsung,pmu-syscon : a phandle to the PMU system controller, no arguments
+
+Example:
+	ufs_phy: ufs-phy@0x15571800 {
+		compatible = "samsung,exynos7-ufs-phy";
+		reg = <0x15571800 0x240>;
+		reg-names = "phy-pma";
+		samsung,pmu-syscon = <&pmu_system_controller>;
+		#phy-cells = <0>;
+	};
-- 
1.7.10.4
