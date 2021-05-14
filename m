Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94742C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 06:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6201E61446
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 06:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhENGVZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 02:21:25 -0400
Received: from verein.lst.de ([213.95.11.211]:49376 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230130AbhENGVX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 May 2021 02:21:23 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2045B67373; Fri, 14 May 2021 08:20:08 +0200 (CEST)
Date:   Fri, 14 May 2021 08:20:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 1/8] core: Introduce scsi_get_sector()
Message-ID: <20210514062007.GA5901@lst.de>
References: <20210513223757.3938-1-bvanassche@acm.org> <20210513223757.3938-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513223757.3938-2-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 13, 2021 at 03:37:50PM -0700, Bart Van Assche wrote:
> Since scsi_get_lba() returns a sector_t value instead of the LBA, the name
> of that function is confusing. Introduce an identical function
> scsi_get_sector(). A later patch will remove scsi_get_lba().

Why not just do a quick rename in a single patch instead of the hard to
review series?
