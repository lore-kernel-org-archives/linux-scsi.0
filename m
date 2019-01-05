From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 1/3] dt-bindings: ufs: Add HI3670 UFS controller binding
Date: Sat,  5 Jan 2019 12:58:57 +0530
Message-ID: <20190105072859.9134-2-manivannan.sadhasivam@linaro.org>
References: <20190105072859.9134-1-manivannan.sadhasivam@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190105072859.9134-1-manivannan.sadhasivam@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, liwei213@huawei.com, robh+dt@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, john.stultz@linaro.org, amit.kucheria@linaro.org, guodong.xu@linaro.org, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
List-Id: linux-scsi@vger.kernel.org

Add devicetree binding for HI3670 UFS controller. HI3760 SoC is very
similar to HI3660 SoC with almost same IPs. Only major difference in terms
of UFS is the PHY. HI3670 has 10nm PHY. But since the original driver
(HI3660 UFS) cannot make HI3670 UFS functional, a separate compatible
is added for HI3670 without any fallback.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 Documentation/devicetree/bindings/ufs/ufs-hisi.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
index a48c44817367..0b83df1a5418 100644
--- a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
+++ b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
@@ -6,9 +6,10 @@ Each UFS Host Controller should have its own node.
 Required properties:
 - compatible        : compatible list, contains one of the following -
 					"hisilicon,hi3660-ufs", "jedec,ufs-1.1" for hisi ufs
-					host controller present on Hi36xx chipset.
+					host controller present on Hi3660 chipset.
+					"hisilicon,hi3670-ufs", "jedec,ufs-2.1" for hisi ufs
+					host controller present on Hi3670 chipset.
 - reg               : should contain UFS register address space & UFS SYS CTRL register address,
-- interrupt-parent  : interrupt device
 - interrupts        : interrupt number
 - clocks	        : List of phandle and clock specifier pairs
 - clock-names       : List of clock input name strings sorted in the same
-- 
2.17.1
