Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 153D3C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00F6060EB2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhGVS3c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 14:29:32 -0400
Received: from verein.lst.de ([213.95.11.211]:35668 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229977AbhGVS3b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jul 2021 14:29:31 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 12EDF67373; Thu, 22 Jul 2021 21:10:05 +0200 (CEST)
Date:   Thu, 22 Jul 2021 21:10:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 12/24] block: add a queue_max_sectors_bytes helper
Message-ID: <20210722191004.GB14921@lst.de>
References: <20210712054816.4147559-1-hch@lst.de> <20210712054816.4147559-13-hch@lst.de> <yq1tukmw7o2.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1tukmw7o2.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 22, 2021 at 02:00:57PM -0400, Martin K. Petersen wrote:
> Maybe simply queue_max_bytes()?

Fine with me.
