Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321E4C63706
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Dec 2022 16:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiLGQbi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 11:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiLGQbf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 11:31:35 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A501D66D;
        Wed,  7 Dec 2022 08:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5Nr2HN/QvkKmAnTHNO48T6RDV2gQD2S0zZ5w1++whvc=; b=33H/bYnfmLHTsf22bqT/+BJI6G
        3GuaN+y20Jf4cG+bZDjST39Z/fS/4vig1N0wOPj94fv65UmliQzO6uOe8qLSAx21CjWkb+oJP+fR/
        J1gPqMJzF7CyoaySIBrYNZimTz4rBHKgDyRCqnPIPXrrlDpx110EwyF5Bb8kqFlaHYBF6Yb7Ux1SH
        KJ5LvyJM9YMc4tQqyz5SG7TaUJF26zJEPMA5Q/ovilbR6Gv52NofU6GJmJAgnA8feYFfDXIlPM7Qj
        00DYiQybT/wMrfdM2c2N/R7BR1hwX5zkngLgEL+5inveWTChkNxRYMvVuv/CAajS7NkIsKh+xClWT
        X44l7thg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p2xKS-006gtH-E1; Wed, 07 Dec 2022 16:31:28 +0000
Date:   Wed, 7 Dec 2022 08:31:28 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Alvaro Karsz <alvaro.karsz@solid-run.com>,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Message-ID: <Y5C/4H7Ettg/DcRz@infradead.org>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <Y5BCQ/9/uhXdu35W@infradead.org>
 <20221207052001-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207052001-mutt-send-email-mst@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 07, 2022 at 05:21:48AM -0500, Michael S. Tsirkin wrote:
> Christoph you acked the spec patch adding this to virtio blk:
> 
> 	Still not a fan of the encoding, but at least it is properly documented
> 	now:
> 
> 	Acked-by: Christoph Hellwig <hch@lst.de>
> 
> Did you change your mind then? Or do you prefer a different encoding for
> the ioctl then? could you help sugesting what kind?

Well, it is good enough documented for a spec.  I don't think it is
a useful feature for Linux where virtio-blk is our minimum viable
paravirtualized block driver.
