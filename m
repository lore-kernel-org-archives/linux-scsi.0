Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3913C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE90A60551
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243376AbhI1X4b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:56:31 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:8287 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243323AbhI1X4Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 19:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632873284; x=1664409284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2TBgNgbXD+9VkJ/zbw10wfQm5ul4uiK1ODKrlqAsW+I=;
  b=malFWeFkTRr7HZjnqWXQ9QbeVZHgCL2W9fUA0LjtuW4W+TawsKMaNSAE
   026vESmS/KfADcl+e2SchpKUz1NDvRCnPM6zHB0ahAoyR3aJ01+P8XTgg
   XAOO7I7pp/VIqp7eSwiMCIIe7NLZRc9/01/i2EphNHkZ3qQYUb+2I3D5Z
   Ab3BY1gnai+fNhCKuT1VA6vIsxsNEzZhe8P4aXZ9u64WOlTzjI1puWhuV
   i4NsmvCc9M7PM7aBE3lLLu5vTe1+S/8icKWK301NYEq2Stcs8oM1r7gfq
   gOjRTywNxeGjLO4tPJ6QPmz9aCG8og93RZf71SYEfM4ZHiJuliBktwfJQ
   g==;
IronPort-SDR: luY3H5KJ/KQCFNkZdOenap+4cau8YmNCUDd9VDrYVrnPJW3mJJCnwfoPb4rr+ZmFOhPXGdfz69
 6TWJ9QnPOMOWwO4GsG2KSf5Uh1Jw6dfoxZcTIWzBpqrLeGeO8RWlBo7VPqyu/35lODRCXULN+j
 yYvq18q1etg8aLuA2LkU7dnXNi+fkCdPhA2BApFCN6R3GRn0uDkoPwtTuG9tlQiADecDXtY7Ut
 nunCiDDHKHN4vm3sAQssXTjWKxxlaLEPd1pObi1rsL/OEcVOb9M4xS/yWL+g1mN55OuUCepfI3
 VlpflSZ79qUaxk9uF7u82fRy
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="138333251"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 16:54:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 16:54:43 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 16:54:42 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 9DE63702943; Tue, 28 Sep 2021 18:54:42 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates PATCH V2 11/11] smartpqi: update version to 2.1.12-055
Date:   Tue, 28 Sep 2021 18:54:42 -0500
Message-ID: <20210928235442.201875-12-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210928235442.201875-1-don.brace@microchip.com>
References: <20210928235442.201875-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update driver version to reflect changes.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ffa217874352..b966ce3b4385 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -33,11 +33,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"2.1.10-020"
+#define DRIVER_VERSION		"2.1.12-055"
 #define DRIVER_MAJOR		2
 #define DRIVER_MINOR		1
-#define DRIVER_RELEASE		10
-#define DRIVER_REVISION		20
+#define DRIVER_RELEASE		12
+#define DRIVER_REVISION		55
 
 #define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"
-- 
2.28.0.rc1.9.ge7ae437ac1

