Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECDEC4332D
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 11:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CBC12333D
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 11:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbhATL0b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 06:26:31 -0500
Received: from verein.lst.de ([213.95.11.211]:55360 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730182AbhATKLY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Jan 2021 05:11:24 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3816168B02; Wed, 20 Jan 2021 11:10:41 +0100 (CET)
Date:   Wed, 20 Jan 2021 11:10:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>
Subject: Re: [PATCH v2 2/2] block: document zone_append_max_bytes attribute
Message-ID: <20210120101040.GC25746@lst.de>
References: <20210119131723.1637853-1-damien.lemoal@wdc.com> <20210119131723.1637853-3-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119131723.1637853-3-damien.lemoal@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
