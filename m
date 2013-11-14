From: Loc Ho <lho@apm.com>
Subject: [PATCH 3/3] arm64: Add APM X-Gene SoC 6.0Gbps SATA PHY DTS entries
Date: Thu, 14 Nov 2013 12:31:59 -0700
Message-ID: <1384457519-21335-4-git-send-email-lho@apm.com>
References: <1384457519-21335-1-git-send-email-lho@apm.com>
 <1384457519-21335-2-git-send-email-lho@apm.com>
 <1384457519-21335-3-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:58419 "HELO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755285Ab3KNTcg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2013 14:32:36 -0500
Received: by mail-pb0-f51.google.com with SMTP id xa7so2455086pbc.38
        for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2013 11:32:34 -0800 (PST)
In-Reply-To: <1384457519-21335-3-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Loc Ho <lho@apm.com>

arm64: Add APM X-Gene SoC 6.0Gbps SATA PHY DTS entries.

This patch adds the DTS entries for the APM X-Gene SoC 6.0Gbps SATA PHY 
driver. The PHY for controller 0 and 1 are enabled by default.
---
 arch/arm64/boot/dts/apm-storm.dtsi |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 359d7b6..b29b465 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -193,5 +193,30 @@
 			reg = <0x0 0x17000014 0x0 0x100>;
 			mask = <0x1>;
 		};
+
+		sataphy0: sataphy@1f210000 {
+			compatible = "apm,xgene-ahci-phy";
+			id = <0>;
+			reg = <0x0 0x1f210000 0x0 0x10000>;
+			#phy-cells = <0>;
+			status = "na";
+		};
+
+		sataphy1: sataphy@1f220000 {
+			compatible = "apm,xgene-ahci-phy";
+			id = <1>;
+			reg = <0x0 0x1f220000 0x0 0x10000>;
+			#phy-cells = <0>;
+			status = "ok";
+		};
+
+		sataphy2: sataphy@1f230000 {
+			compatible = "apm,xgene-ahci-phy";
+			id = <2>;
+			reg = <0x0 0x1f230000 0x0 0x10000
+			       0x0 0x1f2d0000 0x0 0x10000 >;
+			#phy-cells = <0>;
+			status = "ok";
+		};
 	};
 };
-- 
1.5.5

