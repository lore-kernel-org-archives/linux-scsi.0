Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA79FC001B0
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 13:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbjHKN33 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 09:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235734AbjHKN32 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 09:29:28 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDBF26A0;
        Fri, 11 Aug 2023 06:29:28 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9C07767373; Fri, 11 Aug 2023 15:29:23 +0200 (CEST)
Date:   Fri, 11 Aug 2023 15:29:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v7 3/7] scsi: core: Retry unaligned zoned writes
Message-ID: <20230811132923.GA21553@lst.de>
References: <20230809202355.1171455-1-bvanassche@acm.org> <20230809202355.1171455-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809202355.1171455-4-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just as last time:  comparing the lbas really has no business in the
SCSI core.

