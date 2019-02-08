From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: [PATCH v4 5/7] arm64: dts: qcom: msm8998: Allow drivers to set-load
Date: Fri, 8 Feb 2019 23:15:20 +0100
Message-ID: <31519816-a641-ebfe-64c7-039aff074187@free.fr>
References: <09ce9c20-c47b-f936-a8a9-6c8ec8f0f867@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <09ce9c20-c47b-f936-a8a9-6c8ec8f0f867@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: MSM <linux-arm-msm@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Rob Herring <robh+dt@kernel.org>, Kishon Vijay Abraham <kishon@ti.com>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Martin Petersen <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The UFS host controller driver needs to set the load on 3 power rails
(l20, l26, s4) but the operation fails silently unless we specify the
regulator-allow-set-load property in the corresponding DT nodes.

Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
---
 arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi b/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi
index f0901067b043..19775cae1381 100644
--- a/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi
@@ -111,6 +111,7 @@
 		vreg_s4a_1p8: s4 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
+			regulator-allow-set-load;
 		};
 		vreg_s5a_2p04: s5 {
 			regulator-min-microvolt = <1904000>;
@@ -195,6 +196,7 @@
 		vreg_l20a_2p95: l20 {
 			regulator-min-microvolt = <2960000>;
 			regulator-max-microvolt = <2960000>;
+			regulator-allow-set-load;
 		};
 		vreg_l21a_2p95: l21 {
 			regulator-min-microvolt = <2960000>;
@@ -221,6 +223,7 @@
 		vreg_l26a_1p2: l26 {
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1200000>;
+			regulator-allow-set-load;
 		};
 		vreg_l28_3p0: l28 {
 			regulator-min-microvolt = <3008000>;
-- 
2.17.1
