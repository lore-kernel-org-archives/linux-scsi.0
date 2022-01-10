Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA576C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 08:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241909AbiAJIxC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 03:53:02 -0500
Received: from verein.lst.de ([213.95.11.211]:37600 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240574AbiAJIu7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jan 2022 03:50:59 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1455C68AA6; Mon, 10 Jan 2022 09:50:48 +0100 (CET)
Date:   Mon, 10 Jan 2022 09:50:47 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     hch@lst.de, linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] pmcraid: don't use GFP_DMA in pmcraid_alloc_sglist
Message-ID: <20220110085047.GA6124@lst.de>
References: <20211222092247.928711-1-hch@lst.de> <b14613cc-afbd-752b-e338-a5372a8ea3a7@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b14613cc-afbd-752b-e338-a5372a8ea3a7@wanadoo.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 05, 2022 at 09:35:12PM +0100, Christophe JAILLET wrote:
> some time ago I sent a patch because the address returned by
> sgl_alloc_order() isn't saved anywhere and really look like a bogus allocation and certainly a memory leak.
>
> See https://lore.kernel.org/linux-kernel/20200920075722.376644-1-christophe.jaillet@wanadoo.fr/

Can you resubmit that patch?
