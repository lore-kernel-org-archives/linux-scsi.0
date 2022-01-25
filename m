Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D326C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 06:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245133AbiAYGVF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 01:21:05 -0500
Received: from verein.lst.de ([213.95.11.211]:34082 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244139AbiAYGRv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jan 2022 01:17:51 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id E9A0B68C4E; Tue, 25 Jan 2022 07:17:42 +0100 (CET)
Date:   Tue, 25 Jan 2022 07:17:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 10/13] block: add helper of disk_release_queue for
 release queue data for disk
Message-ID: <20220125061742.GB26495@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-11-ming.lei@redhat.com> <20220124131624.GI27269@lst.de> <Ye816Xu9gPU7Q8Ug@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye816Xu9gPU7Q8Ug@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 25, 2022 at 07:27:37AM +0800, Ming Lei wrote:
> > Please explain what "queue data for disk" is, and why this helper is
> 
> Here it means elevator, blk-cgroup and rq qos, all actually serve FS
> IOs, maybe it should be changed to FS IOs.
> 
> > useful.  Right now it seems to just move a few things around without a
> > rationale or explanation of why it is safe.
> 
> This patch just moves two function calls into the helper, and there
> doesn't have functional change, so no need rationale and explanation.

Yes, it it does.  If you move calls into a "helper" that has a single
caller and a weird name it better have a good explanation, because the
move does not look useful at all.
