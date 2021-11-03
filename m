Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69697C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 540C960F39
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbhKCQFi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:05:38 -0400
Received: from verein.lst.de ([213.95.11.211]:59997 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232068AbhKCQFg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Nov 2021 12:05:36 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 964D268AFE; Wed,  3 Nov 2021 17:02:57 +0100 (CET)
Date:   Wed, 3 Nov 2021 17:02:57 +0100
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
Subject: Re: [PATCH v2 02/13] nvdimm/btt: use goto error labels on
 btt_blk_init()
Message-ID: <20211103160257.GB31562@lst.de>
References: <20211103122157.1215783-1-mcgrof@kernel.org> <20211103122157.1215783-3-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103122157.1215783-3-mcgrof@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
