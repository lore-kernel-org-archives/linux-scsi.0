Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E3DC2B9F4
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 04:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06FAA611BF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 04:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhFVEfA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 00:35:00 -0400
Received: from verein.lst.de ([213.95.11.211]:44953 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhFVEe7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 00:34:59 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 62D9467357; Tue, 22 Jun 2021 06:32:42 +0200 (CEST)
Date:   Tue, 22 Jun 2021 06:32:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Ed Tsai <ed.tsai@mediatek.com>
Subject: Re: [PATCH] scsi: Inline scsi_mq_alloc_queue()
Message-ID: <20210622043242.GA27397@lst.de>
References: <20210622024654.12543-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622024654.12543-1-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 21, 2021 at 07:46:54PM -0700, Bart Van Assche wrote:
> Since scsi_mq_alloc_queue() only has one caller, inline it. This change
> was suggested by Christoph Hellwig.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
