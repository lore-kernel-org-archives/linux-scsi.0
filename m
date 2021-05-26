Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E877FC47089
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 01:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB50D6124B
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 01:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhEZBIZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 21:08:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22729 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232667AbhEZBIZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 May 2021 21:08:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621991214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jBcfq2p0pN9Qz0LbsD4Z/VukVJFc1SF/tvTiN/nRRh0=;
        b=S3WOW/cSqO4BUxRbqzdd8vTCnZ2bgE0V4WPvyYK82Yd4fnTmsQVp15G7TCr1PfgiSQxjQw
        QJAgS6kUZOIfFSGzcOsXEUgkRBCswqK7lV+Dx34ivBBki09FDRA8keRt4mf683KhJwIs5+
        WOHE74nn++j1+2HgjKjyo2ijYLwe+lw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-sci2CHxJPliPyOZ_x8kZyw-1; Tue, 25 May 2021 21:06:51 -0400
X-MC-Unique: sci2CHxJPliPyOZ_x8kZyw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A67A4180FD61;
        Wed, 26 May 2021 01:06:49 +0000 (UTC)
Received: from T590 (ovpn-12-85.pek2.redhat.com [10.72.12.85])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C9EC5C1D5;
        Wed, 26 May 2021 01:06:40 +0000 (UTC)
Date:   Wed, 26 May 2021 09:06:34 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/8] block: move bd_mutex to struct gendisk
Message-ID: <YK2fGuOJlnnoRINk@T590>
References: <20210525061301.2242282-1-hch@lst.de>
 <20210525061301.2242282-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525061301.2242282-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 25, 2021 at 08:12:56AM +0200, Christoph Hellwig wrote:
> Replace the per-block device bd_mutex with a per-gendisk open_mutex,
> thus simplifying locking wherever we deal with partitions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

