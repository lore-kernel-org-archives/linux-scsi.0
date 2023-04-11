Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72A8C7619A
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 06:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjDKGTR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 02:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjDKGTP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 02:19:15 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27D5102;
        Mon, 10 Apr 2023 23:19:14 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 43F6568BFE; Tue, 11 Apr 2023 08:19:12 +0200 (CEST)
Date:   Tue, 11 Apr 2023 08:19:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Niklas Cassel <nks@flawful.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH v6 18/19] ata: libata: set read/write commands CDL index
Message-ID: <20230411061911.GJ18719@lst.de>
References: <20230406113252.41211-1-nks@flawful.org> <20230406113252.41211-19-nks@flawful.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406113252.41211-19-nks@flawful.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
