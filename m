From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v1 3/3] arm64: Fix the APM X-Gene SoC SATA PHY clock DTS node csr-mask of the SATA Host Controller 1.
Date: Mon, 23 Jun 2014 15:45:38 +0530
Message-ID: <1403518538-30697-4-git-send-email-stripathi@apm.com>
References: <1403518538-30697-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:57872 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751789AbaFWKQ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jun 2014 06:16:29 -0400
In-Reply-To: <1403518538-30697-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

This patch fixes the SATA PHY clock DTS node csr-mask of the SATA
Host controller 1. This patch also fixes the status of the PHY
clock node of SATA Host controller 1.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index f8c40a6..d14bcc4 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -184,9 +184,9 @@
 				reg = <0x0 0x1f21c000 0x0 0x1000>;
 				reg-names = "csr-reg";
 				clock-output-names = "sataphy1clk";
-				status = "disabled";
+				status = "ok";
 				csr-offset = <0x4>;
-				csr-mask = <0x00>;
+				csr-mask = <0x3a>;
 				enable-offset = <0x0>;
 				enable-mask = <0x06>;
 			};
--
1.8.2.1

