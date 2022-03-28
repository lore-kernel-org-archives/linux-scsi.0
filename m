Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD51C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Mar 2022 08:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239461AbiC1IoP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Mar 2022 04:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235537AbiC1IoP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2022 04:44:15 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D14517EC
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 01:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648456953; x=1679992953;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8JcYPT7+Xmk3GK6CAxs4RWHgTCAaWjNzOC36U4Q8QVA=;
  b=hdDzlQItM+6LjuCZUpHCqSdxaMfoegGQTuybFO5C1BJq3CBVYal/CEz5
   r//nAQz8nhsEKwcVI2pJGGD46aFk6tNxz4luN9JvPKYXoiuvIUmnwziHc
   wP8kaLtUbNShIh54XcnIWCxouGGZG1IkxLCzEWRXXXDdFG1gTK9wF/VfR
   W1zRPJwm3x3syPrl/YR9tCINVzcTKPQlq2hvgVBSrZ/kcHBmV4o25EiGP
   8E2bGg3p2yUMPOoiYZ0juP5cTkMJ7o7cjVm44n4U0fFabVajU8G5DlIP3
   I4oJuAN0LZpA9Mf4ddpdoUriL/nBQsNk7orvAaX1031UYcwrMFmmxpBPg
   A==;
X-IronPort-AV: E=Sophos;i="5.90,216,1643698800"; 
   d="scan'208";a="90337602"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Mar 2022 01:42:32 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 28 Mar 2022 01:42:32 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 28 Mar 2022 01:42:32 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>,
        <john.garry@huawei.com>, Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 0/2] pm80xx updates
Date:   Mon, 28 Mar 2022 04:42:41 -0400
Message-ID: <20220328084243.301493-1-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset includes bugfixes for pm80xx driver

Ajish Koshy (2):
  scsi: pm80xx: mask and unmask upper interrupt vectors 32-63
  scsi: pm80xx: enable upper inbound, outbound queues

 drivers/scsi/pm8001/pm80xx_hwi.c | 42 ++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 5 deletions(-)

-- 
2.31.1

