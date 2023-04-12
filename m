Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE8FC77B73
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 05:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjDLFej (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 01:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDLFei (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 01:34:38 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB31CB9;
        Tue, 11 Apr 2023 22:34:37 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id F2F3868BFE; Wed, 12 Apr 2023 07:34:32 +0200 (CEST)
Date:   Wed, 12 Apr 2023 07:34:32 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Niklas Cassel <nks@flawful.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v6 09/19] scsi: allow enabling and disabling command
 duration limits
Message-ID: <20230412053432.GA18941@lst.de>
References: <20230406113252.41211-1-nks@flawful.org> <20230406113252.41211-10-nks@flawful.org> <20230411061648.GD18719@lst.de> <e9cf65ce-e1f0-4d99-31e7-75b8e88e2a89@kernel.org> <20230411072317.GA22683@lst.de> <15ad7cf9-e385-9cea-964a-4a2eac35385c@kernel.org> <ZDVLsIi/OhkxNcGb@x1-carbon> <85d6ea79-eda1-de58-6ce4-1fab90335ac8@kernel.org> <20230412044348.GA17806@lst.de> <3ac7f4a1-eaa6-d1db-3056-b0ed6681ef36@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ac7f4a1-eaa6-d1db-3056-b0ed6681ef36@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 12, 2023 at 02:32:30PM +0900, Damien Le Moal wrote:
> It is T10 rather than T13 that screwed up: if SPC also defined a CDL feature
> on/off through mode sense/select, we would not need any "if (is_ata)"...
> For ATA/T13, the on/off makes sense because of the mutual exclusion with NCQ
> priority.

Same persons really, so they should know better..
