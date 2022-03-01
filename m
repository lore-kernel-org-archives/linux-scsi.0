Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1348DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 15:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbiCAP4W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 10:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbiCAP4V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 10:56:21 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3543BBE2
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 07:55:40 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1282868BEB; Tue,  1 Mar 2022 16:55:38 +0100 (CET)
Date:   Tue, 1 Mar 2022 16:55:37 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 3/5] lpfc: use fc_block_rport()
Message-ID: <20220301155537.GB6717@lst.de>
References: <20220301143718.40913-1-hare@suse.de> <20220301143718.40913-4-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301143718.40913-4-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 01, 2022 at 03:37:16PM +0100, Hannes Reinecke wrote:
> Use fc_block_rport() instead of fc_block_scsi_eh() as the SCSI command
> will be removed as argument for SCSI EH functions.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
