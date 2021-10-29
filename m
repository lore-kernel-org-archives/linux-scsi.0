Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B2CC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 10:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6B83610CF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 10:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhJ2K4Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 06:56:24 -0400
Received: from verein.lst.de ([213.95.11.211]:45265 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231719AbhJ2K4X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Oct 2021 06:56:23 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 54AA068AFE; Fri, 29 Oct 2021 12:53:53 +0200 (CEST)
Date:   Fri, 29 Oct 2021 12:53:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     axboe@kernel.dk, alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
Message-ID: <20211029105353.GA25156@lst.de>
References: <20211026071204.1709318-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026071204.1709318-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Given that the discussion is now turning into bikeshedding wether the
non-public UFS spec is mereley completly broken or utterly completely
broken can we please add this patch or the revert before 5.15
goes in?  I don't think this mess will be resolved in any reasonable
time.
