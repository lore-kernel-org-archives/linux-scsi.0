Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1338C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 10:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3E8B6137D
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 10:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236113AbhHWKXT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 06:23:19 -0400
Received: from verein.lst.de ([213.95.11.211]:47292 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236089AbhHWKXS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 06:23:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2BDAC67357; Mon, 23 Aug 2021 12:22:33 +0200 (CEST)
Date:   Mon, 23 Aug 2021 12:22:33 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        oliver.sang@intel.com
Subject: Re: [PATCH 18/24] scsi_ioctl: move the "block layer" SCSI ioctl
 handling to drivers/scsi
Message-ID: <20210823102233.GA4110@lst.de>
References: <20210724072033.1284840-1-hch@lst.de> <20210724072033.1284840-19-hch@lst.de> <20210823084316.4bb224e0.pasic@linux.ibm.com> <20210823064936.GA21806@lst.de> <20210823121944.3403c096.pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823121944.3403c096.pasic@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 23, 2021 at 12:19:44PM +0200, Halil Pasic wrote:
> This patch is directly based on f2542a3be327 ("scsi: scsi_ioctl: Move
> the "block layer" SCSI ioctl handling to drivers/scsi") from linux-next, 
> and a simple rebase onto the tip of linux-next does not work because the
> block of code I'm about to modify got factored out into a function
> called scsi_ioctl_sg_io().
> 
> I'm not sure about the process of fixes in linux-next, so can please
> somebody (Christoph, Martin) tell me against what base should I post the
> respin (in a separate thread)?

Just send the fix ontop of linux-next (or rather Martin's scsi tree,
but they should be the same in this area).
