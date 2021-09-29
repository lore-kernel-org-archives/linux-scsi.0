Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBE9C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 09:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62DE7613A9
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 09:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239961AbhI2JT2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 05:19:28 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50575 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhI2JT1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 05:19:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632907065; x=1664443065;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=57qehLTu9OWs4BMsuxbZ8aBcqfAoSZnnVqUikPgKn0I=;
  b=lavvibBMSxGV3D2iCt9o3kBDbZ6VqZjvA7mVXcNEE1RgmB+x/Taxf4Up
   QYRPotqoyGapFfXOAAzKG8LZnP2JQ7HW/c0DuWl/qqd20qfknGCDv2Ns0
   UyHmNUkPb+Tmn3vJBeytfYD/NRuDAO8NlLdCnnZErafUHlC97HIu09WEp
   130/1AoEN8eDqR9fezVCK0xaAMgc3JH0J9nlFkZBddOBhn1mq29lmz8s2
   enV+3xTBv81Mv4mntR/OxjqHquAKGCcFndoMik0tELinYmdejgJ8JHI1V
   VhYsOpXf/5yLHK/kNESV/TTb3h4kVEA44vFVDxvLVHZelVbA6pop97Jo/
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,331,1624291200"; 
   d="scan'208";a="181291268"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Sep 2021 17:17:45 +0800
IronPort-SDR: hjWpD/XtGW2ekGkOf4kHOcVFnppRQEAUxmeaifV1QKJBXM4z3/JMwP2sPPdTUXQktb2FMnONRp
 nQ6cAWbI0lH5iYALEVDh0wQSIto9/2GPJAT/JAmz76uT15RsSNjecGPBaG4KVffglm0bqR9mGj
 WOUFVl4+8/BnBimYz5MITPyTd+/xQCMLjCzDaKcF3EPyxE7K5rAKZN6718PkwVGRYh1Hn43EsQ
 a2K0/MvkguH8xt33RqLv+Nzn2yDeJ53BWNKnrwUXRdkap3+wyIw12imQ7v+WCs1RzDM3rof+yh
 uzrkvqAqWTguVag5j/66hNCk
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 01:52:17 -0700
IronPort-SDR: ywoNhy+dQWFIJ/WItxl3Os9+CkBmx85jRz8pZG+kqMFWaQmwaiDLSRYiUFul1odOIdZqoJQOiw
 d79W+c8teI4qPGXJok/u9nLVP5UworOFLpEKUjsPTQsNZ9elhYKTvDuoBIqvGaqkwIQS17nNNP
 erHiamkAjSblBExi6t6YeGFH5J/akPxaWa5V54kP3D+NYg62W9p6+ThCaUEuE/TpvUp092WpAR
 TaYLPT7AhECHMvProFQhsdy4K8pdBHf97MsMmGkrinHaKb/Pr3zsIyFaQxwcJGFTwMcuSxEWQd
 kn4=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 29 Sep 2021 02:17:46 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0/2] small cleanups
Date:   Wed, 29 Sep 2021 18:17:42 +0900
Message-Id: <20210929091744.706003-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Here is a couple of patches ifor some light cleanup in scsi_lib.
No functional changes are introduced.

Damien Le Moal (2):
  scsi: simplify scsi_get_vpd_page()
  scsi: fix scsi_mode_select() interface

 drivers/scsi/scsi.c        | 31 ++++++++++++++-----------------
 drivers/scsi/scsi_lib.c    |  8 +++-----
 drivers/scsi/sd.c          |  2 +-
 include/scsi/scsi_device.h |  5 ++---
 4 files changed, 20 insertions(+), 26 deletions(-)

-- 
2.31.1

