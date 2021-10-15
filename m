Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F6DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 23:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3684E611C1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 23:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239020AbhJOXUh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 19:20:37 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:38298 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229741AbhJOXUf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 19:20:35 -0400
X-UUID: 25a2eccd0dc445e1a5bbf513c075a338-20211016
X-UUID: 25a2eccd0dc445e1a5bbf513c075a338-20211016
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1093777851; Sat, 16 Oct 2021 07:18:23 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Sat, 16 Oct 2021 07:18:22 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 16 Oct 2021 07:18:22 +0800
From:   Miles Chen <miles.chen@mediatek.com>
To:     <bvanassche@acm.org>
CC:     <jejb@linux.ibm.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <martink@posteo.de>,
        <matthias.bgg@gmail.com>, <miles.chen@mediatek.com>,
        <stanley.chu@mediatek.com>, <wsd_upstream@mediatek.com>
Subject: Re: [PATCH] scsi: sd: fix crashes in sd_resume_runtime
Date:   Sat, 16 Oct 2021 07:18:05 +0800
Message-ID: <20211015231805.17509-1-miles.chen@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <14930227-aca0-89a0-25ea-727d263f8bf8@acm.org>
References: <14930227-aca0-89a0-25ea-727d263f8bf8@acm.org>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Thanks for the clarification. Given this clarification I'm fine with your patch.

> Bart.


thanks for your review

Miles
