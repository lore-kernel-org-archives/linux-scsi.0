From: Loc Ho <lho@apm.com>
Subject: [PATCH v2 4/4] arm64: Add APM X-Gene SoC 6.0Gbps SATA PHY DTS entries
Date: Tue, 19 Nov 2013 16:53:17 -0700
Message-ID: <1384905197-3566-5-git-send-email-lho@apm.com>
References: <1384905197-3566-1-git-send-email-lho@apm.com>
 <1384905197-3566-2-git-send-email-lho@apm.com>
 <1384905197-3566-3-git-send-email-lho@apm.com>
 <1384905197-3566-4-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:58700 "HELO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753505Ab3KSXxt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2013 18:53:49 -0500
Received: by mail-pd0-f179.google.com with SMTP id r10so5891418pdi.10
        for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2013 15:53:48 -0800 (PST)
In-Reply-To: <1384905197-3566-4-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

arm64: Add APM X-Gene SoC 6.0Gbps SATA PHY DTS entries

This patch adds the DTS entries for the APM X-Gene SoC 6.0Gbps SATA PHY
driver. The PHY for controller 0 and 1 are enabled by default.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 359d7b6..1d1c8bc 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -193,5 +193,33 @@
 			reg = <0x0 0x17000014 0x0 0x100>;
 			mask = <0x1>;
 		};
+
+		sataphy0: sataphy@1f210000 {
+			compatible = "apm,xgene-ahci-phy";
+			reg = <0x0 0x1f210000 0x0 0x10000>;
+			#phy-cells = <0>;
+			status = "na";
+			txbooster = <0x2 0x2 0x2 0x2 0x2 0x2>;
+			txskew = <0xa 0xa 0xa 0xa 0xa 0xa>;
+		};
+
+		sataphy1: sataphy@1f220000 {
+			compatible = "apm,xgene-ahci-phy";
+			reg = <0x0 0x1f220000 0x0 0x10000>;
+			#phy-cells = <0>;
+			status = "ok";
+			txbooster = <0x2 0x2 0x2 0x2 0x2 0x2>;
+			txskew = <0xa 0xa 0xa 0x5 0x5 0x5>;
+		};
+
+		sataphy2: sataphy@1f230000 {
+			compatible = "apm,xgene-ahci-phy2";
+			reg = <0x0 0x1f230000 0x0 0x10000
+			       0x0 0x1f2d0000 0x0 0x10000>;
+			#phy-cells = <0>;
+			status = "ok";
+			txbooster = <0x3 0x3 0x3 0x3 0x3 0x3>;
+			txskew = <0xa 0xa 0xa 0xc 0xc 0xc>;
+		};
 	};
 };
-- 
1.5.5

