Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45957C43461
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 13:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 190AD60FE7
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 13:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353613AbhESNY3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 09:24:29 -0400
Received: from verein.lst.de ([213.95.11.211]:38334 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353606AbhESNY2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 May 2021 09:24:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2610A67373; Wed, 19 May 2021 15:23:06 +0200 (CEST)
Date:   Wed, 19 May 2021 15:23:05 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Song Liu <song@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/8] block: split __blkdev_get
Message-ID: <20210519132305.GA13174@lst.de>
References: <20210512061856.47075-1-hch@lst.de> <20210512061856.47075-2-hch@lst.de> <YKTYgaL4nAej+jeY@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKTYgaL4nAej+jeY@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 19, 2021 at 05:21:05PM +0800, Ming Lei wrote:
> Nice cleanup, now the blkdev get code becomes more readable than before:

Note that this will need a rebase on top of the partition rescan fix.
I'll send that out once Jens has merged the fix.
