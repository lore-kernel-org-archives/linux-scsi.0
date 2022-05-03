Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422E2C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 14:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbiECONV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 10:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbiECONV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 10:13:21 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D188338DAA
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 07:09:48 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3E53B68D07; Tue,  3 May 2022 16:09:46 +0200 (CEST)
Date:   Tue, 3 May 2022 16:09:46 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 10/24] ibmvfc: use fc_block_rport()
Message-ID: <20220503140946.GJ22590@lst.de>
References: <20220502213820.3187-1-hare@suse.de> <20220502213820.3187-11-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502213820.3187-11-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 02, 2022 at 11:38:06PM +0200, Hannes Reinecke wrote:
> Use fc_block_rport() instead of fc_block_scsi_eh() as the latter
> will be deprecated.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
