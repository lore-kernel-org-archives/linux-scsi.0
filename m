Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A714C64E7B
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 16:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EF2A21D7F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 16:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388964AbgLBQXY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 11:23:24 -0500
Received: from verein.lst.de ([213.95.11.211]:54872 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbgLBQXY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Dec 2020 11:23:24 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id DB5F768AFE; Wed,  2 Dec 2020 17:22:42 +0100 (CET)
Date:   Wed, 2 Dec 2020 17:22:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 07/34] aic7xxx,aic79xx: kill pointless forward
 declarations
Message-ID: <20201202162242.GC32254@lst.de>
References: <20201202115249.37690-1-hare@suse.de> <20201202115249.37690-8-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202115249.37690-8-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
