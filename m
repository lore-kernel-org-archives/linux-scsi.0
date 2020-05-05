Return-Path: <SRS0=dRcH=6T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD74C47258
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 12:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 147C22073B
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 12:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgEEMnN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 May 2020 08:43:13 -0400
Received: from verein.lst.de ([213.95.11.211]:35163 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728569AbgEEMnM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 May 2020 08:43:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 135E768C4E; Tue,  5 May 2020 14:43:08 +0200 (CEST)
Date:   Tue, 5 May 2020 14:43:08 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tim Waugh <tim@cyberelk.net>, Borislav Petkov <bp@alien8.de>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] hfs: stop using ioctl_by_bdev
Message-ID: <20200505124308.GA26266@lst.de>
References: <20200504135927.2835750-1-hch@lst.de> <20200504135927.2835750-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504135927.2835750-6-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Jens,

can you pick up this patch as well?  I forgot about hfs earlier and this
was only added to the most recent resend.  The changes are identical to
those in hfsplus.
