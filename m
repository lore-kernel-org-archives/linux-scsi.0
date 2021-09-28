Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D28C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49C4861246
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbhI1SqS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 14:46:18 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35632 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhI1SqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 14:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632854678; x=1664390678;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=;
  b=VTN6X72CJbfkZhFY3rcEtNV65+axl3oRsQ5lcLdnPfomcscYan5i9LGx
   zk6Yy+mpxL3B8NFeXD3vMiVRk/T7sKTtRCq0EbAVuDCDaqSjyqCG/NS/R
   wBuIqpHDWqhnf1D+SbQAPXuNlVt4zMTJWZDkMSCyxWD3bkMnmDHAMRmkA
   wDF+j7hkrwwOAiTLwSwe+IM+6NUlbr9Q8w+6LRtl94bHgCyTHvhCwQytP
   NQCd+UsB53mLbcPuHCfjoBgx7t10mmvqzN9RSPQYQ3Qt/PhMeDi+D3uUA
   q45t9KKtwmUwc2ikBnyz9IbMfMSKcS51DoYRaamMRoee2451VyTHF7cXj
   g==;
IronPort-SDR: p3Kf2qpANPlrgAv8FIkeFOOJzTWoSmB47Y993Q4sxQYcrBkveMH46iiu0ZsziW3ZC2x2F/v5Km
 4peMe1sB+zYxR74ViPXf9wO1QWkpPBPSUuJsYwhhkQRTQp981Ya5TKrwPiMG77frV8epv1cGuG
 bEJxWGYq8ZGPhnvy5kDgz1oi9n2iPt442v36yKp8+omo2QOq2e6ilvhXBLfnbv8eDNJKKuWvPV
 IaCY3QZrRDewVKcpYq865yEE/xEAF+YjqXFAO0XUATKjdN6ClKNiNqrKBJjRD0pqphZtXU/PyU
 mi12OJrzzqlrQ7w5TTx7kb75
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="137712436"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 11:44:35 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 11:44:34 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 11:44:34 -0700
Subject: [PATCH 00/11] smartpqi updates
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 28 Sep 2021 13:44:34 -0500
Message-ID: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.1+40.g1b20.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


