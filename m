Return-Path: <SRS0=5MTk=YA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C8F4ECE58C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76E14206C0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbfJGWcG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 18:32:06 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:17316 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729413AbfJGWcG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Oct 2019 18:32:06 -0400
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=don.brace@microsemi.com; spf=None smtp.helo=postmaster@email.microchip.com
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  don.brace@microsemi.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="don.brace@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:68.232.147.0/24 ip4:68.232.148.0/22 ip4:68.232.152.0/23
  ip4:68.232.154.0/24 ip4:216.71.150.0/24 ip4:216.71.151.0/24
  ip4:216.71.152.0/23 ip4:216.71.154.0/24 ip4:198.175.253.41
  ip4:198.175.253.82 include:servers.mcsv.net -all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: Xk+OZBpa/orQcEvgCV1e0jt06b6+vd9SqTaK3y1Mvew3Z938kGvggiPJLroWkrYGJG5hGAL7KH
 CuxsKE3UwVtYMD5Xtp350T0xhvpeCfKHS4okmyVX4r3L0Xu5Z1KF3SXihQlROjN/SCCLzbKlX8
 Eth9KnN4nWXPrSR7XVONSl6gtdYS/wyctli3Ml04HN0IIkIif2NC18HOOJWpi8Dg2W20g75UJA
 eZV8m1nFHF/W6M+OCA5pSHrlMQdZvNBMY53cLH+2rQovA6npV2+8WyQY21Dfrr+xaiNQlqNhO/
 HPI=
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="49125761"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2019 15:32:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 7 Oct 2019 15:32:04 -0700
Received: from [127.0.1.1] (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 7 Oct 2019 15:32:04 -0700
Subject: [PATCH 08/10] smartpqi: remove unused manifest constants
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 7 Oct 2019 17:32:04 -0500
Message-ID: <157048752420.11757.3464951542864727227.stgit@brunhilda>
In-Reply-To: <157048745695.11757.6602264644727193780.stgit@brunhilda>
References: <157048745695.11757.6602264644727193780.stgit@brunhilda>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

- removed some unused manifest constants

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 068336904477..c42bf033109e 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -958,13 +958,9 @@ struct pqi_scsi_dev {
 };
 
 /* VPD inquiry pages */
-#define SCSI_VPD_SUPPORTED_PAGES	0x0	/* standard page */
-#define SCSI_VPD_DEVICE_ID		0x83	/* standard page */
 #define CISS_VPD_LV_DEVICE_GEOMETRY	0xc1	/* vendor-specific page */
 #define CISS_VPD_LV_BYPASS_STATUS	0xc2	/* vendor-specific page */
 #define CISS_VPD_LV_STATUS		0xc3	/* vendor-specific page */
-#define SCSI_VPD_HEADER_SZ		4
-#define SCSI_VPD_DEVICE_ID_IDX		8	/* Index of page id in page */
 
 #define VPD_PAGE	(1 << 8)
 

