Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF1DC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 07:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBBB461165
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 07:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbhDSHKi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 03:10:38 -0400
Received: from verein.lst.de ([213.95.11.211]:45400 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237563AbhDSHKh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Apr 2021 03:10:37 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EFB8067373; Mon, 19 Apr 2021 09:10:04 +0200 (CEST)
Date:   Mon, 19 Apr 2021 09:10:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2 3/3] zonefs: fix synchronous write to sequential
 zone files
Message-ID: <20210419071004.GA19600@lst.de>
References: <20210417023323.852530-1-damien.lemoal@wdc.com> <20210417023323.852530-4-damien.lemoal@wdc.com> <20210419064529.GA19041@lst.de> <BL0PR04MB651477B7ECC57FA61E1C99EFE7499@BL0PR04MB6514.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR04MB651477B7ECC57FA61E1C99EFE7499@BL0PR04MB6514.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 19, 2021 at 07:08:46AM +0000, Damien Le Moal wrote:
> 1) refuse to mount if ZA is disabled, same as btrfs

Yes, please do that.
