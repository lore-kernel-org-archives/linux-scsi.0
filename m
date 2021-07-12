Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05F9C11FEE
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 07:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A7566144D
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 07:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345797AbhGLHpX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 03:45:23 -0400
Received: from verein.lst.de ([213.95.11.211]:51520 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234130AbhGLHh6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Jul 2021 03:37:58 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D1CA467373; Mon, 12 Jul 2021 09:35:02 +0200 (CEST)
Date:   Mon, 12 Jul 2021 09:35:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V3 03/10] blk-mq: pass use managed irq info to
 blk_mq_dev_map_queues
Message-ID: <20210712073501.GC12347@lst.de>
References: <20210709081005.421340-1-ming.lei@redhat.com> <20210709081005.421340-4-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709081005.421340-4-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As requested by me and Thomas please just add a flag in struct device
to propagate this information in a way that does not require all this
error probe boilerplate code.
