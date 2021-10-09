Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC392C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 07:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8505160F90
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 07:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhJIHlt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Oct 2021 03:41:49 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24180 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhJIHls (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2021 03:41:48 -0400
Received: from dggeme754-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HRH3Z2YD3z1DGn9;
        Sat,  9 Oct 2021 15:38:18 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggeme754-chm.china.huawei.com
 (10.3.19.100) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.8; Sat, 9 Oct
 2021 15:39:49 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH v2 0/2] Fix out-of-bound read in resp_readcap16 and resp_report_tgtpgs
Date:   Sat, 9 Oct 2021 15:52:29 +0800
Message-ID: <20211009075231.2489878-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme754-chm.china.huawei.com (10.3.19.100)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ye Bin (2):
  scsi:scsi_debug: Fix out-of-bound read in resp_readcap16
  scsi:scsi_debug:Fix out-of-bound read in resp_report_tgtpgs

 drivers/scsi/scsi_debug.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

-- 
2.31.1

