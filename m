Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FDB1C352BE
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 18:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EFDA206D6
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 18:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgDPSRS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 14:17:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:45962 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbgDPSRS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 14:17:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 865D5AB71;
        Thu, 16 Apr 2020 18:17:15 +0000 (UTC)
Date:   Thu, 16 Apr 2020 20:17:14 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 03/11] block: rename __bio_add_pc_page to
 bio_add_hw_page
Message-ID: <20200416181714.yjzqg3x6nlxzqfbt@carbon>
References: <20200415090513.5133-1-johannes.thumshirn@wdc.com>
 <20200415090513.5133-4-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415090513.5133-4-johannes.thumshirn@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 15, 2020 at 06:05:05PM +0900, Johannes Thumshirn wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Rename __bio_add_pc_page() to bio_add_hw_page() and explicitly pass in a
> max_sectors argument.
> 
> This max_sectors argument can be used to specify constraints from the
> hardware.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [ jth: rebased and made public for blk-map.c ]
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

As far as I can tell, it looks good.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
