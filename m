Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8EE7C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 07:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B04164E13
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 07:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhBVHNO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 02:13:14 -0500
Received: from verein.lst.de ([213.95.11.211]:57319 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229949AbhBVHNN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 02:13:13 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4934A68D0A; Mon, 22 Feb 2021 08:12:30 +0100 (CET)
Date:   Mon, 22 Feb 2021 08:12:30 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, chriscjsus@yahoo.com,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi/sd: Fix Opal support
Message-ID: <20210222071230.GA20510@lst.de>
References: <20210222021042.3534-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222021042.3534-1-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
