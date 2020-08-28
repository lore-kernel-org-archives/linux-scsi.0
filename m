Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E1FC433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 21:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B88362086A
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 21:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgH1VJN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 17:09:13 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:52998 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgH1VJM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 17:09:12 -0400
IronPort-SDR: ILcDB2abZk/BKygvRB/kcRTsU01lTUAfv0xVyKVxXEZfOwgmWEub45fwNqhoU566o/ChdL6FZf
 +UKN8JStKpzXW44ZJRyDOVHoJOPV4Gkydai8NpdZkA9tGcpGpwBVL9alJYAzpDv0FeKRRoPaqr
 nraDFkYYyNO2OYDvy0kjiLyPyjbrlnb6Od10xl5PZ60POCyvvniFAVcD0QYramfQm6E01cCb1t
 aCpRx6Bya7xMjnrMp6BxQrtSAhEmSdgoFXXphzo5eogJo7OmY2Aq/0WLbAflHayD+xIZDNnEUv
 8cw=
X-IronPort-AV: E=Sophos;i="5.76,365,1592895600"; 
   d="scan'208";a="88999009"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Aug 2020 14:09:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 28 Aug 2020 14:09:04 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 28 Aug 2020 14:09:03 -0700
Subject: [PATCH 0/2] smartpqi updates
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 28 Aug 2020 16:09:09 -0500
Message-ID: <159864889781.13630.2796712754333982084.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

This small set of changes consist of:
 * Changing e-mail address to Microchip
 * Changing storagedev from esc.storagedev@microsemi.com
   to storagedev@microchip.com

---

Don Brace (2):
      smartpqi: update documentation
      smartpqi: update copyright


 drivers/scsi/smartpqi/Kconfig                  | 4 ++--
 drivers/scsi/smartpqi/smartpqi.h               | 2 +-
 drivers/scsi/smartpqi/smartpqi_init.c          | 2 +-
 drivers/scsi/smartpqi/smartpqi_sas_transport.c | 2 +-
 drivers/scsi/smartpqi/smartpqi_sis.c           | 2 +-
 drivers/scsi/smartpqi/smartpqi_sis.h           | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

--
Signature
