Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BA5C64E7C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 16:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBAE821D7F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 16:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389032AbgLBQWF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 11:22:05 -0500
Received: from verein.lst.de ([213.95.11.211]:54860 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389013AbgLBQWF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Dec 2020 11:22:05 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1CD5368AFE; Wed,  2 Dec 2020 17:21:20 +0100 (CET)
Date:   Wed, 2 Dec 2020 17:21:18 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 01/34] scsi: drop gdth driver
Message-ID: <20201202162118.GA32254@lst.de>
References: <20201202115249.37690-1-hare@suse.de> <20201202115249.37690-2-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202115249.37690-2-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 02, 2020 at 12:52:16PM +0100, Hannes Reinecke wrote:
> The gdth driver refers to a SCSI parallel, PCI-only HBA RAID adapter
> which was manufactured by the now-defunct ICP Vortex company, later
> acquired by Adaptec and superseded by the aacraid series of controllers.
> The driver itself would require a major overhaul before any modifications
> can be attempted, but seeing that it's unlikely to have any users left
> it should rather be removed completely.

The driver is pretty horrible, so I'm not going to complain if it
goes away.  Let's hope one relies on it, and we don't have to bring
it back..

Cautiously-Acked-by: Christoph Hellwig <hch@lst.de>

Once this driver is gone we can also remove scsi_get_host_dev and
scsi_free_host_dev.
