Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AA1C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 09:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7990861051
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 09:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237840AbhHTJ4f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 05:56:35 -0400
Received: from verein.lst.de ([213.95.11.211]:40392 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236384AbhHTJ4d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Aug 2021 05:56:33 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EF18167373; Fri, 20 Aug 2021 11:55:54 +0200 (CEST)
Date:   Fri, 20 Aug 2021 11:55:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 2/3] ncr53c8xx: Complete all commands during bus reset
Message-ID: <20210820095554.GB9733@lst.de>
References: <20210820095405.12801-1-hare@suse.de> <20210820095405.12801-3-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820095405.12801-3-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
