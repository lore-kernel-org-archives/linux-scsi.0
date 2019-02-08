From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: [PATCH v4 2/7] dt-bindings: ufs: Add msm8998 compatible string
Date: Fri, 8 Feb 2019 23:11:50 +0100
Message-ID: <17069590-0fed-032b-3b05-ba4631582fed@free.fr>
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

Add "qcom,msm8998-ufshc" compatible string.

Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
---
 Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index 5111e9130bc3..991e21ee7b44 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -11,6 +11,7 @@ Required properties:
 			  the appropriate jedec string:
 			    "qcom,msm8994-ufshc", "qcom,ufshc", "jedec,ufs-2.0"
 			    "qcom,msm8996-ufshc", "qcom,ufshc", "jedec,ufs-2.0"
+			    "qcom,msm8998-ufshc", "qcom,ufshc", "jedec,ufs-2.0"
 			    "qcom,sdm845-ufshc", "qcom,ufshc", "jedec,ufs-2.0"
 - interrupts        : <interrupt mapping for UFS host controller IRQ>
 - reg               : <registers mapping>
-- 
2.17.1
