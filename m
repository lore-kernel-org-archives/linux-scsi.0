From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: [PATCH v5 1/3] dt-bindings: ufs: Add msm8998 compatible string
Date: Mon, 25 Feb 2019 13:17:02 +0100
Message-ID: <0cda2a1e-6fb1-c46c-0358-0d7f5e03b2d2@free.fr>
References: <43768d77-80b7-9cdc-b6e0-08ec4a026c21@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <43768d77-80b7-9cdc-b6e0-08ec4a026c21@free.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: MSM <linux-arm-msm@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, LKML <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>
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
