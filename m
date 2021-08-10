Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88ADC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 08:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C187E60EFF
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 08:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbhHJIZo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 04:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhHJIZn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 04:25:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B964C0613D3;
        Tue, 10 Aug 2021 01:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Q9qR8WR5ADVgrKCTVAH8R6cB3D
        eMC64O86b3FS1l4SSV5RW7imh7BvjHt+RGJJ+PFKmH/qkMxnMs0jUWj8uBKh8PD4Phcyx0j1+O+Am
        sHZT13VbcPaeSTf0f9vdSwTgdSn+CYtwgVeA6urkXC12TnVvqsshMdhkjjy8AVU7MqDHh7FL0cUk0
        EMPDpEPIrFbZIidCCcJglStNrl8+ZYoTeIJdkPSoSnctGtU2VO4Br06usuW1CThRBShS2Ui4Eu5LU
        Gz1GtaKVCSWXbk/hVEFe88BOMki/1/JW4KoJT7ZvGDXj3UvUghmk1LQD/Ng+iN38vrquUJMdUri85
        6CMkd+FQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDN41-00BtEh-Gx; Tue, 10 Aug 2021 08:24:56 +0000
Date:   Tue, 10 Aug 2021 09:24:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 2/4] scsi: sd: add concurrent positioning ranges
 support
Message-ID: <YRI3zf0DmUmD8wC7@infradead.org>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <20210726013806.84815-3-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726013806.84815-3-damien.lemoal@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
