Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBDDC77B7A
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 05:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbjFGFKu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 01:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbjFGFKt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 01:10:49 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79321726;
        Tue,  6 Jun 2023 22:10:48 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D6C8268AA6; Wed,  7 Jun 2023 07:10:45 +0200 (CEST)
Date:   Wed, 7 Jun 2023 07:10:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2 2/3] scsi: sg: increase number of devices
Message-ID: <20230607051045.GB20052@lst.de>
References: <20230606193845.9627-1-mwilck@suse.com> <20230606193845.9627-3-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606193845.9627-3-mwilck@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 06, 2023 at 09:38:44PM +0200, mwilck@suse.com wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Larger setups may need to allocate more than 32k sg devices, so
> increase the number of devices to the full range of minor device
> numbers.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Same comment about the signoff.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
