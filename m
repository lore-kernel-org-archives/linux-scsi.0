Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED63C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FB83610FC
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbhKCQJP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:09:15 -0400
Received: from verein.lst.de ([213.95.11.211]:60066 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229776AbhKCQJO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Nov 2021 12:09:14 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B8F6768AA6; Wed,  3 Nov 2021 17:06:35 +0100 (CET)
Date:   Wed, 3 Nov 2021 17:06:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, hch@lst.de, penguin-kernel@i-love.sakura.ne.jp,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, richard@nod.at,
        miquel.raynal@bootlin.com, vigneshr@ti.com, efremov@linux.com,
        song@kernel.org, martin.petersen@oracle.com, hare@suse.de,
        jack@suse.cz, ming.lei@redhat.com, tj@kernel.org,
        linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/13] nvdimm/pmem: cleanup the disk if
 pmem_release_disk() is yet assigned
Message-ID: <20211103160635.GF31562@lst.de>
References: <20211103122157.1215783-1-mcgrof@kernel.org> <20211103122157.1215783-7-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103122157.1215783-7-mcgrof@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2021 at 05:21:50AM -0700, Luis Chamberlain wrote:
> Prior to devm being able to use pmem_release_disk() there are other
> failure which can occur for which we must account for and release the
> disk for. Address those few cases.
> 
> Fixes: 3dd60fb9d95d ("nvdimm/pmem: stop using q_usage_count as external pgmap refcount")
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
