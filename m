Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4CCC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 14:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237067AbiECOdQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 10:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbiECOdQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 10:33:16 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E090331341
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 07:29:43 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3DB5367373; Tue,  3 May 2022 16:29:40 +0200 (CEST)
Date:   Tue, 3 May 2022 16:29:40 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 09/11] xen-scsifront: add scsi device as argument to
 scsifront_do_request()
Message-ID: <20220503142940.GG24492@lst.de>
References: <20220502215416.5351-1-hare@suse.de> <20220502215416.5351-10-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502215416.5351-10-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 02, 2022 at 11:54:14PM +0200, Hannes Reinecke wrote:
> Add scsi device as argument to scsifront_do_request() so that it
> will be possible to call it with a NULL command pointer.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
