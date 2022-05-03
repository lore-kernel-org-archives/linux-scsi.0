Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C9F0C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 14:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbiECOXa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 10:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbiECOX1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 10:23:27 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3D626AC4
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 07:19:54 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 565DC67373; Tue,  3 May 2022 16:19:52 +0200 (CEST)
Date:   Tue, 3 May 2022 16:19:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 19/24] snic: Use scsi_host_busy_iter() to traverse
 commands
Message-ID: <20220503141951.GC23742@lst.de>
References: <20220502213820.3187-1-hare@suse.de> <20220502213820.3187-20-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502213820.3187-20-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The real question is why that driver even manually iterates the tags.
But as I'm glad the EH work is making progress I'm happy to defer that
question:

Reviewed-by: Christoph Hellwig <hch@lst.de>
