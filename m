Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828C8C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 14:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236743AbiECOOP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 10:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236729AbiECOOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 10:14:14 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328E9120BF
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 07:10:42 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8E0F168D09; Tue,  3 May 2022 16:10:39 +0200 (CEST)
Date:   Tue, 3 May 2022 16:10:39 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 12/24] fnic: use fc_block_rport() correctly
Message-ID: <20220503141039.GL22590@lst.de>
References: <20220502213820.3187-1-hare@suse.de> <20220502213820.3187-13-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502213820.3187-13-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 02, 2022 at 11:38:08PM +0200, Hannes Reinecke wrote:
> Use fc_block_rport() instead of fc_block_scsi_eh() and evaluate
> the return value to avoid issuing TMF commands when the port
> is still blocked.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
