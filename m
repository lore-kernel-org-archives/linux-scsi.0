Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE5BCCA479
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jun 2022 05:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238339AbiFTF6h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jun 2022 01:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiFTF6f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2022 01:58:35 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6815DEB1;
        Sun, 19 Jun 2022 22:58:32 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6EF536732D; Mon, 20 Jun 2022 07:58:28 +0200 (CEST)
Date:   Mon, 20 Jun 2022 07:58:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
        bvanassche@acm.org, hch@lst.de, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hare@suse.de, satishkh@cisco.com,
        sebaddel@cisco.com, kartilak@cisco.com, linux-rdma@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, nbd@other.debian.org
Subject: Re: [PATCH 1/5] scsi: core: Remove reserved request time-out
 handling
Message-ID: <20220620055828.GA10192@lst.de>
References: <1655463320-241202-1-git-send-email-john.garry@huawei.com> <1655463320-241202-2-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655463320-241202-2-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 17, 2022 at 06:55:16PM +0800, John Garry wrote:
> The SCSI code does not currently support reserved commands. As such,
> requests which time-out would never be reserved, and scsi_timeout()
> 'reserved' arg should never be set.
> 
> Remove handling for reserved requests and drop wrapper scsi_timeout() as
> it now just calls scsi_times_out() always.

Please rename scsi_times_out to scsi_timeout so it still matches the
method name.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
