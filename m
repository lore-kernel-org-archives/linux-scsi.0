Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15CEC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D644961262
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242249AbhI1SrU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 14:47:20 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:18685 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242214AbhI1SrT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 14:47:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632854740; x=1664390740;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=;
  b=Dagm6P/p9ayF2Dg9wlbrsTl+w9H27G70K5W/zPlIxCzC7H2H8aMC/ZDU
   z56sffwPrUmT3WM5Goivi0AFGf0C1T0XRWm/7QpJCTq+fryXFuOZZeqay
   fW+HIZe1KAn3IzQr9IpfY77oK0RWpQiCITQxnLUgn3z/ULDElb1teCAu6
   dltnJQXEa+bjMhiXhIzIiX9OuHx7Z83ddM6TzMuXb668l/UWKWRaEAYcL
   m2fcweEBkBF2+DAoBc02WN+GmQRkfEyqf6LxzBXZWqRGQrk4cZBpfUVqP
   O+dnwmaBOUaj+LQ8MqzC8roZCzO+2ibYOsztsbnskTkk72HgW/YXDKRhh
   w==;
IronPort-SDR: F4t18LRrUv/l/PK03n4EI35APWIJh0wuXiE8ce/6hO8syWcuxegpxW2coMUW3+CqDHoDWw5Ats
 W/F1DeYiokaeRg0MG3t6+SNZj+2o0tZvLypBzEiieu1wGKfT7Xn6FWrHbet6XcygmTIoj6szbc
 y0/JCGrOQ35nlP/dLdxoOSUSzknzerDJWLoK/9sppOWooDfY7eRVTc/mD/Ety1RwrnYlWFTKrr
 UudKoZGIejB5oHfZjlA3hpL3naDi94wUKeQ6SvlKzVPGvPzTi3XvdbWyx++HdOfGssY4oWyG3c
 yBbsowSjI7WaH692RNovOLCE
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="130992535"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 11:45:39 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 11:45:39 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 11:45:38 -0700
Subject: [PATCH 11/11] smartpqi: update version to 2.1.12-055
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 28 Sep 2021 13:45:38 -0500
Message-ID: <163285473882.194893.8692041174969763680.stgit@brunhilda.pdev.net>
In-Reply-To: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
References: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.1+40.g1b20.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


