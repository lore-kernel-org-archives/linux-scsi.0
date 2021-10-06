Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768EAC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 05:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50E52610C9
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 05:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhJFFlS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 01:41:18 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:54972 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229579AbhJFFlS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 01:41:18 -0400
X-UUID: cd6e1cf328d94e3593d9577f198af917-20211006
X-UUID: cd6e1cf328d94e3593d9577f198af917-20211006
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 659223351; Wed, 06 Oct 2021 13:39:23 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 6 Oct 2021 13:39:21 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 Oct 2021 13:39:21 +0800
Message-ID: <70550eb4364fd184682d14543fc5c1f9810a93f2.camel@mediatek.com>
Subject: Re: [PATCH v3 0/2] scsi: ufs: support vops pre suspend for mediatek
 to disable auto-hibern8
From:   Peter Wang <peter.wang@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <jonathan.hsu@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <mikebi@micron.com>
Date:   Wed, 6 Oct 2021 13:39:21 +0800
In-Reply-To: <fda69919-44d3-1150-7141-a71e5900bb20@acm.org>
References: <20211006030959.20533-1-peter.wang@mediatek.com>
         <fda69919-44d3-1150-7141-a71e5900bb20@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-10-05 at 21:02 -0700, Bart Van Assche wrote:
> On 10/5/21 20:09, peter.wang@mediatek.com wrote:
> > Mediatek UFS design need disable auto-hibern8 before suspend.
> > This patch introduce an solution to do pre suspned before SSU
> > (sleep) command.
> > 
> > Peter Wang (2):
> >    scsi: ufs: support vops pre suspend
> >    scsi: ufs: ufs-mediatek: disable auto-hibern8 before suspend
> 
> Please always include a changelog when posting a new version of a
> patch
> series.
> 
> I have the same comment about v3 as for v2: I don't think that this
> series is bisectable so please combine the two patches into one patch
> or add "if (status == PRE_CHANGE) return" in ufshcd_vops_suspend() in
> patch 1/2 and remove this again in patch 2/2.
> 
> Thanks,
> 
> Bart.

Hi Bart,

OK, will merge to one patch.
Thanks for review.

Peter


