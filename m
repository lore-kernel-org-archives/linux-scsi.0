From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 1/3] devicetree: bindings: scsi: hisi_sas add hip07 support
Date: Tue, 4 Oct 2016 19:11:09 +0800
Message-ID: <1475579471-11308-2-git-send-email-john.garry@huawei.com>
References: <1475579471-11308-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:46438 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbcJDKuE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2016 06:50:04 -0400
In-Reply-To: <1475579471-11308-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linuxarm@huawei.com, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, hare@suse.com, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>

Add support for hip07 chipset to hisi_sas controller.

Chipset hip07 has v2 hw.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
index bf2411f..2a42a32 100644
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
-- 
1.9.1

