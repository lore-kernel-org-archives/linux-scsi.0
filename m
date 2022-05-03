Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA91C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 14:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236716AbiECOMH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 10:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbiECOMF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 10:12:05 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15B53879A
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 07:08:33 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 466BA68CFE; Tue,  3 May 2022 16:08:31 +0200 (CEST)
Date:   Tue, 3 May 2022 16:08:31 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Saurav Kashyap <skashyap@marvell.com>
Subject: Re: [PATCH 07/24] qedf: use fc rport as argument for
 qedf_initiate_tmf()
Message-ID: <20220503140831.GG22590@lst.de>
References: <20220502213820.3187-1-hare@suse.de> <20220502213820.3187-8-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502213820.3187-8-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 02, 2022 at 11:38:03PM +0200, Hannes Reinecke wrote:
> When sending a TMF we're only concerned with the rport and the LUN ID,
> so use struct fc_rport as argument for qedf_initiate_tmf().

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
