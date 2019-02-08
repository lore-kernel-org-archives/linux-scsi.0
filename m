From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: [PATCH v4 3/7] dt-bindings: phy-qcom-qmp: Add
 qcom,msm8998-qmp-ufs-phy
Date: Fri, 8 Feb 2019 23:13:16 +0100
Message-ID: <dade6a09-ab00-82f6-eb5b-bc2b09ed5162@free.fr>
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

Add compatible string for QMP UFS phy on msm8998.

Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
---
 Documentation/devicetree/bindings/phy/qcom-qmp-phy.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom-qmp-phy.txt b/Documentation/devicetree/bindings/phy/qcom-qmp-phy.txt
index 4ff26dbf4310..5d181fc3cc18 100644
--- a/Documentation/devicetree/bindings/phy/qcom-qmp-phy.txt
+++ b/Documentation/devicetree/bindings/phy/qcom-qmp-phy.txt
@@ -10,6 +10,7 @@ Required properties:
 	       "qcom,msm8996-qmp-pcie-phy" for 14nm PCIe phy on msm8996,
 	       "qcom,msm8996-qmp-usb3-phy" for 14nm USB3 phy on msm8996,
 	       "qcom,msm8998-qmp-usb3-phy" for USB3 QMP V3 phy on msm8998,
+	       "qcom,msm8998-qmp-ufs-phy" for UFS QMP phy on msm8998,
 	       "qcom,sdm845-qmp-usb3-phy" for USB3 QMP V3 phy on sdm845,
 	       "qcom,sdm845-qmp-usb3-uni-phy" for USB3 QMP V3 UNI phy on sdm845,
 	       "qcom,sdm845-qmp-ufs-phy" for UFS QMP phy on sdm845.
@@ -45,6 +46,8 @@ Required properties:
 			"aux", "cfg_ahb", "ref".
 		For "qcom,msm8998-qmp-usb3-phy" must contain:
 			"aux", "cfg_ahb", "ref".
+		For "qcom,msm8998-qmp-ufs-phy" must contain:
+			"ref", "ref_aux".
 		For "qcom,sdm845-qmp-usb3-phy" must contain:
 			"aux", "cfg_ahb", "ref", "com_aux".
 		For "qcom,sdm845-qmp-usb3-uni-phy" must contain:
@@ -66,6 +69,7 @@ Required properties:
 			"phy", "common".
 		For "qcom,msm8998-qmp-usb3-phy" must contain
 			"phy", "common".
+		For "qcom,msm8998-qmp-ufs-phy": no resets are listed.
 		For "qcom,sdm845-qmp-usb3-phy" must contain:
 			"phy", "common".
 		For "qcom,sdm845-qmp-usb3-uni-phy" must contain:
-- 
2.17.1
