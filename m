Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D748C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B5A022D01
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgLDXEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:04:35 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:1478 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgLDXEe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:04:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607123074; x=1638659074;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RFHTOJk4jL1L+AndjkrMk4I5uYjcqb32AdpDg2Rd02w=;
  b=viKSNspFoUGOAuvWbhs2C7dRpI744UuDSm4WMz9lVLDe0QnNlpSzDv+Z
   YBbKCGjIXUQuf4afjrWLZg5uM3VcA2ZKf6CV+FiRiBtefogkOpsZQ8vuA
   7SRndO0mHBmKEen3KQL5HtqLMoMD88ykplq4pSxTeRBuOrxVZvmGdr9+z
   1BGjPdsSWYouf261gWrftyUioq8qkfectrxlgZiFBRSlMKmHXEmIAUOop
   7FSfX0XZGt6fC1U1fjl2PXX/yPicYehujw5dVcBvwTLZAuatPX/+LZ7P6
   +AYiwtzt8hKzJnwKJDTHpjBqdYSBGiAogbImjopCCBHse5sRKVwF6UMvV
   w==;
IronPort-SDR: Lfe9yF4M96NeK4OjkZcurMVwBzanpttOeORHNHDBlkxbI1VN27wuvflDVVksgHwewDmMROXl2E
 X0vcrsPuQ74cOvNCtmFLB68uSxn77nldOaGeBJQhjJZ1+oJdKrXW3ZPWwiOF/2ejbtzJQBBGUE
 vwHgcMqznbUVITEk9i2PbzSPEj1s8h89rhK5LNjGN1jXnRnSNOeXctaKRII08qjkMIsgXR18JA
 oG3SSFgG3j0xeQkdWOJuw0X4RZJMCPlDAFj56xyNsDQRlNjodRdsNaKIkf0YBTMs6GwUIXzzex
 kXY=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="101548957"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:03:16 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:03:16 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:03:16 -0700
Subject: [PATCH 25/25] smartpqi: update version to 2.1.6-005
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:03:15 -0600
Message-ID: <160712299585.21372.913012583816104187.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* Update version for tracking

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Gerry Morong <gerry.morong@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 55f3c2d2c52c..2c13c6a19e4c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -33,11 +33,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"1.2.16-012"
-#define DRIVER_MAJOR		1
-#define DRIVER_MINOR		2
-#define DRIVER_RELEASE		16
-#define DRIVER_REVISION		12
+#define DRIVER_VERSION		"2.1.6-005"
+#define DRIVER_MAJOR		2
+#define DRIVER_MINOR		1
+#define DRIVER_RELEASE		6
+#define DRIVER_REVISION		5
 
 #define DRIVER_NAME		"Microsemi PQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"

