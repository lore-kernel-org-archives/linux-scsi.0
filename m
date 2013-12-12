From: Loc Ho <lho@apm.com>
Subject: [PATCH v4 4/4] arm64: Add APM X-Gene SoC 15Gbps Multi-purpose PHY DTS entries
Date: Thu, 12 Dec 2013 00:30:35 -0700
Message-ID: <1386833435-30498-5-git-send-email-lho@apm.com>
References: <1386833435-30498-1-git-send-email-lho@apm.com>
 <1386833435-30498-2-git-send-email-lho@apm.com>
 <1386833435-30498-3-git-send-email-lho@apm.com>
 <1386833435-30498-4-git-send-email-lho@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1386833435-30498-4-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds the DTS entries for the APM X-Gene SoC 15Gbps Multi-purpose
PHY driver. The PHY for SATA controller 0 and 1 are enabled by default.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 359d7b6..e967676 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -193,5 +193,36 @@
 			reg = <0x0 0x17000014 0x0 0x100>;
 			mask = <0x1>;
 		};
+
+		phy1: phy@1f21a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f21a000 0x0 0x100>,
+			      <0x0 0x1f21c000 0x0 0x100>;
+			#phy-cells = <1>;
+			status = "disabled";
+			apm,tx-boost-gain = <0x2 0x3 0x3 0x2 0x3 0x3>;
+			apm,tx-eye-tuning = <0x2 0xa 0xa 0x2 0xa 0xa>;
+		};
+
+		phy2: phy@1f22a000 {
+			compatible = "apm,xgene-phy";
+			reg = <0x0 0x1f22a000 0x0 0x100>,
+			      <0x0 0x1f22c000 0x0 0x100>;
+			#phy-cells = <1>;
+			status = "ok";
+			apm,tx-boost-gain = <0x2 0x3 0x2 0x2 0x3 0x2>;
+			apm,tx-eye-tuning = <0x1 0xa 0xa 0x2 0xa 0x5>;
+		};
+
+		phy3: phy@1f23a000 {
+			compatible = "apm,xgene-phy-ext";
+			reg = <0x0 0x1f23a000 0x0 0x100>,
+			      <0x0 0x1f23c000 0x0 0x100>,
+			      <0x0 0x1f2d0000 0x0 0x100>;
+			#phy-cells = <1>;
+			status = "ok";
+			apm,tx-boost-gain = <0x2 0x3 0x3 0x2 0x3 0x3>;
+			apm,tx-eye-tuning = <0x2 0xa 0xa 0x2 0xa 0xc>;
+		};
 	};
 };
--
1.5.5

