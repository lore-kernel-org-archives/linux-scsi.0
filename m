Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19334C7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 04:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjDLEnz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 00:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDLEny (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 00:43:54 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383FA2D57;
        Tue, 11 Apr 2023 21:43:53 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 224E568BFE; Wed, 12 Apr 2023 06:43:49 +0200 (CEST)
Date:   Wed, 12 Apr 2023 06:43:48 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Niklas Cassel <nks@flawful.org>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v6 09/19] scsi: allow enabling and disabling command
 duration limits
Message-ID: <20230412044348.GA17806@lst.de>
References: <20230406113252.41211-1-nks@flawful.org> <20230406113252.41211-10-nks@flawful.org> <20230411061648.GD18719@lst.de> <e9cf65ce-e1f0-4d99-31e7-75b8e88e2a89@kernel.org> <20230411072317.GA22683@lst.de> <15ad7cf9-e385-9cea-964a-4a2eac35385c@kernel.org> <ZDVLsIi/OhkxNcGb@x1-carbon> <85d6ea79-eda1-de58-6ce4-1fab90335ac8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85d6ea79-eda1-de58-6ce4-1fab90335ac8@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 12, 2023 at 09:59:30AM +0900, Damien Le Moal wrote:
> Good point. If we move the code for cdl_enable to libata, then we will not be
> covering the SAS HBA cases.
> 
> Christoph,
> 
> I do not see a cleaner solution... Can we keep this patch as is ? Any other idea ?

I guess we have to.  But it's really ugly and someone in T13 really needs
to be slapped..
