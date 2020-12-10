Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73FA6C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46ED923E25
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404646AbgLJUhU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:37:20 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:60508 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404642AbgLJUhK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:37:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607632630; x=1639168630;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=08hWukQp0fOLw93JjwrRoGqhi90eIGvdjgFM6rimNiw=;
  b=TmDBmeZuk+QrSEHUI2Yuoqm3DnQ9JVkCF57V1eN0jATl7V6hVgkXghHc
   0P0KA7eIWDe2YBbPQZsBpIN3VgMaAJdvriYWPKIhYdCChiqoU5i3qyfkS
   P6iHUj4/UMzYZW3G1JZOhENIt2cfLxQ2sOZWDHHOK7lrLC669I5tObwoP
   gS4a2oOsgELwC2iQWweXhcAAMFFKsERn8kMQRePEiVSWqlw7JQhpBGlBC
   2rmFqLZn8l2Y2aj3nJRV4fuwHSB6TpnyI5GtjYTkwE6EKINcil1NWa16M
   kh33O/6gUpr9NsRmmHJOTQgHueKmUm0pCl/VMj+505NOegwXMxihmZ1wb
   w==;
IronPort-SDR: R6eCmk12ZxRql4WMPADV3WCzI7KuaJrUjncf2oAMkONtdaCw2LVyOWbcca5TBHYL3/k6J6uJAK
 zdBVzT8BVyHic+Hw8db6iteaLkhacobJ7/pEo0Qsq7ukxu0xq6YqPKSyneUbrOSIdOgE/cl59i
 uih/o2+UOK+BxaVMrAyRb7/auwpVM2BRvLd8jH5sA5uA5bP0sDOJXl75Xu8MWo46GfT6E+hQyY
 vOku/JpnobPh4nXQKFysrDdUHuyjx3cJcTDrFeASjnZ1RgoNrwLahCBksK6sTNUc6pwm0bf6qQ
 a8A=
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="96675191"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 13:36:46 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 13:36:46 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 13:36:45 -0700
Subject: [PATCH V3 25/25] smartpqi: update version to 2.1.6-005
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 10 Dec 2020 14:36:45 -0600
Message-ID: <160763260561.26927.8855667584865677807.stgit@brunhilda>
In-Reply-To: <160763241302.26927.17487238067261230799.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
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
index a0501d09a8a3..89baa9b7023e 100644
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

