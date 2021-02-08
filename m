Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B475C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 17:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D2D764EB6
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 17:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbhBHRTV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 12:19:21 -0500
Received: from verein.lst.de ([213.95.11.211]:42327 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232460AbhBHRSh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Feb 2021 12:18:37 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2835A67373; Mon,  8 Feb 2021 18:17:44 +0100 (CET)
Date:   Mon, 8 Feb 2021 18:17:43 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH v4 0/8] block: add zone write granularity limit
Message-ID: <20210208171743.GA15614@lst.de>
References: <20210128044733.503606-1-damien.lemoal@wdc.com> <BL0PR04MB65147501739ABF4F27B72290E7B39@BL0PR04MB6514.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR04MB65147501739ABF4F27B72290E7B39@BL0PR04MB6514.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 04, 2021 at 08:47:51AM +0000, Damien Le Moal wrote:
> Any comment on this series ?
> 
> Martin,
> 
> The scsi bits (patch 5 and 8) may need your ack.

ping?  Jens, having this series really helps with some of the
ongoing zoned device work.
