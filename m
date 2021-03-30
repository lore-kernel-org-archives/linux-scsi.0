Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84933C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 17:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 588AF619D7
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 17:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhC3R1M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 13:27:12 -0400
Received: from verein.lst.de ([213.95.11.211]:59896 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232307AbhC3R05 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Mar 2021 13:26:57 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 319D368B05; Tue, 30 Mar 2021 19:26:54 +0200 (CEST)
Date:   Tue, 30 Mar 2021 19:26:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/8] advansys: remove ISA support
Message-ID: <20210330172653.GD13829@lst.de>
References: <20210326055822.1437471-1-hch@lst.de> <20210326055822.1437471-5-hch@lst.de> <f02b33b0-a898-505c-24f1-c84c35d21b78@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f02b33b0-a898-505c-24f1-c84c35d21b78@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 29, 2021 at 08:31:21AM +0200, Hannes Reinecke wrote:
> >  #define ASC_IS_PCI          (0x0004)
> >  #define ASC_IS_PCI_ULTRA    (0x0104)
> 
> Any particular reason why the remaining ISA defines (like
> ASC_CHIP_MIN_VER_ISA etc) are being left intact?

I can do that.

> Please remove the 'isa_dma_channel' field from struct asc_dvc_cfg, too.

Sure.  This needs a little tweak as it seems to get written back to
the eeprom, though.
