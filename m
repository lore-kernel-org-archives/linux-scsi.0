From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/3] devicetree: bindings: scsi: hisi_sas hip07 support
Date: Tue, 20 Sep 2016 18:48:58 +0800
Message-ID: <1474368540-186535-2-git-send-email-john.garry@huawei.com>
References: <1474368540-186535-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1474368540-186535-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, devicetree@vger.kernel.org, mark.rutland@arm.com, robh+dt@kernel.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

Add support for hip07 chipset to bindings.

Chipset hip07 has v2 hw.

The sas-v2 quirk amt is expanded to cover hip07.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
index bf2411f..e604527 100644
--- a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
+++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
@@ -6,6 +6,7 @@ Main node required properties:
   - compatible : value should be as follows:
 	(a) "hisilicon,hip05-sas-v1" for v1 hw in hip05 chipset
 	(b) "hisilicon,hip06-sas-v2" for v2 hw in hip06 chipset
+	(c) "hisilicon,hip07-sas-v2" for v2 hw in hip07 chipset
   - sas-addr : array of 8 bytes for host SAS address
   - reg : Address and length of the SAS register
   - hisilicon,sas-syscon: phandle of syscon used for sas control
@@ -47,7 +48,7 @@ Main node required properties:
 			increasing order.
 
 Optional main node properties:
- - hip06-sas-v2-quirk-amt : when set, indicates that the v2 controller has the
+ - hip06/7-sas-v2-quirk-amt : when set, indicates that the v2 controller has the
 			    "am-max-transmissions" limitation.
 
 Example:
-- 
1.9.1
