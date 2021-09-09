Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33743C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 05:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1816E61139
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 05:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350722AbhIIFYC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 01:24:02 -0400
Received: from verein.lst.de ([213.95.11.211]:41231 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350499AbhIIFYB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Sep 2021 01:24:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9CC8567373; Thu,  9 Sep 2021 07:22:49 +0200 (CEST)
Date:   Thu, 9 Sep 2021 07:22:49 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
        axboe@kernel.dk, martin.petersen@oracle.com, hch@lst.de,
        gregkh@linuxfoundation.org, wanghaibin.wang@huawei.com
Subject: Re: [PATCH] scsi: bsg: Fix device unregistration
Message-ID: <20210909052249.GA24029@lst.de>
References: <20210909034608.1435-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909034608.1435-1-yuzenghui@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
