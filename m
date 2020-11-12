Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABDDC55ABD
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 19:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE7BF20B80
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 19:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgKLTW2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Nov 2020 14:22:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:35714 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgKLTW1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Nov 2020 14:22:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9C79EAFF8;
        Thu, 12 Nov 2020 19:22:25 +0000 (UTC)
Date:   Thu, 12 Nov 2020 20:22:23 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Justin Sanders <justin@coraid.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Roger Pau =?iso-8859-2?Q?Monn=E9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, nbd@other.debian.org,
        ceph-devel@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/24] block: remove the update_bdev parameter from
 set_capacity_revalidate_and_notify
Message-ID: <20201112192223.GA17194@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20201111082658.3401686-1-hch@lst.de>
 <20201111082658.3401686-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111082658.3401686-6-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph,

> The update_bdev argument is always set to true, so remove it.  Also
> rename the function to the slighly less verbose set_capacity_and_notify,
> as propagating the disk size to the block device isn't really
> revalidation.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Petr Vorel <pvorel@suse.cz>

Nice cleanup.

Kind regards,
Petr
