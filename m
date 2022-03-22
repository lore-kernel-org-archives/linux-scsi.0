Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD1EC43219
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Mar 2022 11:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbiCVLVe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Mar 2022 07:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiCVLVd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2022 07:21:33 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511BE710F4;
        Tue, 22 Mar 2022 04:20:06 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5B40968AFE; Tue, 22 Mar 2022 12:20:03 +0100 (CET)
Date:   Tue, 22 Mar 2022 12:20:03 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
        bvanassche@acm.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hch@lst.de, ming.lei@redhat.com, hare@suse.de,
        chenxiang66@hisilicon.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com, beanhuo@micron.com
Subject: Re: [PATCH 02/11] scsi: core: Add SUBMITTED_BY_SCSI_CUSTOM_OPS
Message-ID: <20220322112003.GB29270@lst.de>
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com> <1647945585-197349-3-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1647945585-197349-3-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 22, 2022 at 06:39:36PM +0800, John Garry wrote:
> Add a new type of submitter, SUBMITTED_BY_SCSI_CUSTOM_OPS, for when a
> SCSI cmnd is submitted via the block layer but not by scsi_queue_rq().
> 
> Since this is not a true SCSI cmnd we should do nothing for it in
> scsi_done_internal().

CUSTOM_OPS sounds weird.  I think the naming should match the naming
of whatever is used to submit it (haven't read the remaining patches
yet).  And this should probably be folded into the patch that actually
uses it.
