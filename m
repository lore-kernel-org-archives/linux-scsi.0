Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E5EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbiBAVtT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:49:19 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:52981 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235633AbiBAVtT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:49:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752159; x=1675288159;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+KGe2ZJDWmjUSPvLX4NHi36PRKop/Mn9ZXqm7qBQDN4=;
  b=sE9A/i2euLS4zpGxSaz682soFUE+oDyXKZaAdZPg4c0o0KF+gGtuMisV
   spAvvmHwqsdYPMWn5rizNe7gtU2HPFoeeMtRik/DLnPTwfSirFXr7YiR3
   c69ZUlQKk7MmBYgJwl6ZlNhnr7WuHQppYYoJx5TBZ210kmroqP67sm3Hs
   4Gcvn5P8XYjNvAVEKy7p0C1Gq51ThH4tpQLQs0rjUzMv+NNA9wRoXpf3l
   KZHOEtjmjLsbLcSZSpuktUyLERGIZaxbHqKGT8SKQ6+XitC9QrIMKe9Z3
   P20JFt2qTf3mtJWRGo/J8WFfcHrpQuhz4By/ZfJnCkedcQK3Fja8vmaMJ
   A==;
IronPort-SDR: 2MFOorarGqA0vwvpKqi1ONeeeGEQXt3P0CxEK/uvo1WgIJiWrcd6f9G42/MnpY7MVOTz39/3ue
 fhdU2hi9J+cGTHY/AWksQE2irQje2idfyqvTOBp/GJukqzZJbn+jwTyFDq0z8P9ZF8WnHRhCEr
 8qT6D+LG0YBn9Tq/xJnDLfJj+CVFMmTqXKucTYfRu3uo1VPKZegjUXwJq0RMGXMCzABns6G4H/
 xpP02xWVQRz8IW0geIS1QaN82Rb3Cai4ZMfvTpfnbQzHMpGA8oZKqVDEus/UtHvNapG1hQPO6/
 fD0Ff5FbqDIIItuh59H3QKeg
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="151639164"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:49:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:49:18 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:49:18 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id AE8CB70236E;
        Tue,  1 Feb 2022 15:49:18 -0600 (CST)
Subject: [PATCH 18/18] smartpqi: update version to 2.1.14-035
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:49:18 -0600
Message-ID: <164375215867.440833.17567317655622946368.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Gerry Morong <gerry.morong@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index be4e91aaaa52..61366642ea95 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -33,11 +33,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"2.1.12-055"
+#define DRIVER_VERSION		"2.1.14-035"
 #define DRIVER_MAJOR		2
 #define DRIVER_MINOR		1
-#define DRIVER_RELEASE		12
-#define DRIVER_REVISION		55
+#define DRIVER_RELEASE		14
+#define DRIVER_REVISION		35
 
 #define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"


