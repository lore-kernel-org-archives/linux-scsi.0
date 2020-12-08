Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5811BC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3339B23B04
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgLHVHf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:07:35 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:62561 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728568AbgLHVHd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 16:07:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607461652; x=1638997652;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z2X8vlZ3oZEXCm/iPHP7e6ONznSUIDNnAs1sBrwhv60=;
  b=oh36zqbJsDPnFk5uiiZoRrI3a0BikDvr44lgxdVM6vNC0B+HRrvsNIsm
   cTkelDXypVVjN/32/MYL3yiYUOLxrBS5aEz8qJQs3/FJVnRXmHjWn2o6/
   PiDOmaSQIZKV+92B127XsHWP3zmlUNcPC4NxRCP4S7/93RQvhQEl+dwl5
   bDhfhgfO+6oQZK9ryuq4U47kJVXQBNRkKE5eebsKcnBnNmO3LIdFbJzAa
   dY0ke/RQFPJMRoL30IE/t/qKvVnD1fTqcLhTcI8WIZe1V95JHRyFIIVU5
   lrzxsCfSPjM4FAibA+x/W/S8dzGnH4nutkVFMsGPtIapVEBDqISzNYj2f
   A==;
IronPort-SDR: tnHDWamAkwOjN2Klx9tjUTNPYiHtar2kFjk70Nt7ywac/2nRVDzdY1BPi2K7k/sz16ukaTBq2t
 rOtyjrktWocwTpk1PtPtDS4pGG8s0AaiVpeidKgc0o2FBW2AfgZn1DWpc4rUzcK4ZWBxV0ro/w
 Xiebm0xgVpnUWnMNe0gU/M82nVEWTG+hWJ4IwSM4z36buSYK96BcIdSH2+ZsRiq23fFtFUh0gU
 N7dvFIujvnqfHTVu6GaRWwFOKBVC0Kz9dkq/PQ+Ct9Zdby+WeWULaz4xLrBafUJHMJ9FYtZPBy
 HHc=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="36640177"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:39:01 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:39:01 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:39:00 -0700
Subject: [PATCH V2 25/25] smartpqi: update version to 2.1.6-005
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:39:00 -0600
Message-ID: <160745634054.13450.15884798256888277859.stgit@brunhilda>
In-Reply-To: <160745609917.13450.11882890596851148601.stgit@brunhilda>
References: <160745609917.13450.11882890596851148601.stgit@brunhilda>
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
index b709c1ebff6a..746baa84706e 100644
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

