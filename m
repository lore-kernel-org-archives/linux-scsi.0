Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A06C4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 17:16:31 +0000 (UTC)
Received: from vger.kernel.org (unknown [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0C6C20797
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 17:16:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0C6C20797
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-scsi-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732195AbgKPRQI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 12:16:08 -0500
Received: from verein.lst.de ([213.95.11.211]:55240 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727499AbgKPRQI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 12:16:08 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 70CBE68BEB; Mon, 16 Nov 2020 18:16:06 +0100 (CET)
Date:   Mon, 16 Nov 2020 18:16:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v2 3/9] scsi: Pass a request queue pointer to
 __scsi_execute()
Message-ID: <20201116171606.GC22007@lst.de>
References: <20201116030459.13963-1-bvanassche@acm.org> <20201116030459.13963-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116030459.13963-4-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Nov 15, 2020 at 07:04:53PM -0800, Bart Van Assche wrote:
> This patch does not change any functionality but makes a later patch easier
> to read.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
