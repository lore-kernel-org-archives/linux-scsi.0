Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8B0ECAAD3
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 08:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiINIsP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 04:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiINIsO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 04:48:14 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642665F7C7
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 01:48:12 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=kanie@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VPmWG4M_1663145283;
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0VPmWG4M_1663145283)
          by smtp.aliyun-inc.com;
          Wed, 14 Sep 2022 16:48:10 +0800
From:   Guixin Liu <kanie@linux.alibaba.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH 0/5] scsi: megaraid_sas: some bug fixes and cod cleanup
Date:   Wed, 14 Sep 2022 16:47:58 +0800
Message-Id: <1663145283-4872-1-git-send-email-kanie@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

*** BLURB HERE ***

Hi guys,

This series has bug fix and a few simple cleanups, 
please review.

Guixin Liu (5):
  scsi: megaraid_sas: correct the parameter of scsi_device_lookup
  scsi: megaraid_sas: correct an error message
  scsi: megaraid_sas: simplify the megasas_update_device_list
  scsi: megaraid_sas: remove unnecessary memset
  scsi: megaraid_sas: move megasas_dbg_lvl init to megasas_init

 drivers/scsi/megaraid/megaraid_sas_base.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

-- 
1.8.3.1

