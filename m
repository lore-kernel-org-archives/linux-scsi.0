From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/3] devicetree: bindings: scsi: hisi_sas: add LED feature for v2 hw
Date: Thu, 18 Jan 2018 00:46:52 +0800
Message-ID: <1516207614-159721-2-git-send-email-john.garry@huawei.com>
References: <1516207614-159721-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:38183 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752746AbeAQPyj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jan 2018 10:54:39 -0500
In-Reply-To: <1516207614-159721-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>

From: Xiaofei Tan <tanxiaofei@huawei.com>

Add directly attached disk LED feature for v2 hw.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
index b6a869f..df3bef7 100644
--- a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
+++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
@@ -8,7 +8,10 @@ Main node required properties:
 	(b) "hisilicon,hip06-sas-v2" for v2 hw in hip06 chipset
 	(c) "hisilicon,hip07-sas-v2" for v2 hw in hip07 chipset
   - sas-addr : array of 8 bytes for host SAS address
-  - reg : Address and length of the SAS register
+  - reg : Contains two regions. The first is the address and length of the SAS
+          register. The second is the address and length of CPLD register for
+          SGPIO control. The second is optional, and should be set only when
+          we use a CPLD for directly attached disk LED control.
   - hisilicon,sas-syscon: phandle of syscon used for sas control
   - ctrl-reset-reg : offset to controller reset register in ctrl reg
   - ctrl-reset-sts-reg : offset to controller reset status register in ctrl reg
-- 
1.9.1
