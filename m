Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1D1C55181
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 544AB206E9
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgDVGly (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 02:41:54 -0400
Received: from verein.lst.de ([213.95.11.211]:50470 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgDVGly (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 02:41:54 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CE82E68C7B; Wed, 22 Apr 2020 08:41:51 +0200 (CEST)
Date:   Wed, 22 Apr 2020 08:41:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: clean up DMA draining
Message-ID: <20200422064151.GA23271@lst.de>
References: <20200414074225.332324-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414074225.332324-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 14, 2020 at 09:42:20AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> currently the dma draining and alignining specific to ATA CDROMs
> and the UFS driver has its ugly hooks in core block code.  Move
> this out into the scsi and ide drivers instead.

Any commens?
