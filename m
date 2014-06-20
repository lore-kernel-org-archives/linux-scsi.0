From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v0 3/3] aram64: Fix the APM X-Gene SoC SATA PHY clock DTS node csr-mask of the SATA Host Controller 1.
Date: Fri, 20 Jun 2014 14:02:27 +0530
Message-ID: <1403253147-14341-4-git-send-email-stripathi@apm.com>
References: <1403253147-14341-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1403253147-14341-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch fixes the SATA PHY clock DTS node csr-mask of the SATA
Host controller 1.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index f8c40a6..df5896d 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -186,7 +186,7 @@
 				clock-output-names = "sataphy1clk";
 				status = "disabled";
 				csr-offset = <0x4>;
-				csr-mask = <0x00>;
+				csr-mask = <0x3a>;
 				enable-offset = <0x0>;
 				enable-mask = <0x06>;
 			};
--
1.8.2.1

