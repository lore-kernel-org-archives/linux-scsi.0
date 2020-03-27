Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BDCC2D0E5
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7199F20714
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:19:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qGpcqEnp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgC0RTV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 13:19:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43400 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgC0RTV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 13:19:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j2bS3D+Ko5dxkrm6D/CPCyiKFbSrGO2KUMBSyhAldvI=; b=qGpcqEnpl9tjqvp0pDmzhFq6gU
        UJxP+KIznK0+ZbUpWLiCOQKOLhOY8u06CsD1TMRewIFSu21Jpq/jav7Rg9Ua3tEXake4DtvY7qi5x
        huSL9QlLYgAHWUANWW0sCIeD4sWc0H/IuQ12Aek/CITmDBG2mazokfYinbWm30BfjH8Te9Tt0549h
        9Iq45Z5iMvQ06HjeGEDFq350YRC9S9sHGq4O+55VlS5zaXJmBZZUqnmqiwTrx/bJCCJthFxplGlxY
        8F+wiF7M6IZvx8jUq4S6Znbo4XJPoEadb4IwVztCi6pTKXED2FBeyiMdxf/3dYB/Ff479Ri5RJBeE
        Tf8elCGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHsdc-0002Lp-Lu; Fri, 27 Mar 2020 17:19:20 +0000
Date:   Fri, 27 Mar 2020 10:19:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3 03/10] block: introduce blk_req_zone_write_trylock
Message-ID: <20200327171920.GE11524@infradead.org>
References: <20200327165012.34443-1-johannes.thumshirn@wdc.com>
 <20200327165012.34443-4-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327165012.34443-4-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Mar 28, 2020 at 01:50:05AM +0900, Johannes Thumshirn wrote:
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  block/blk-zoned.c      | 14 ++++++++++++++
>  include/linux/blkdev.h |  1 +
>  2 files changed, 15 insertions(+)

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
