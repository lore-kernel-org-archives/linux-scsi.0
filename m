Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A67EC4BA18
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 17:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4627120801
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 17:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgBZRql (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 12:46:41 -0500
Received: from verein.lst.de ([213.95.11.211]:50068 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgBZRqk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 12:46:40 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 522B868CF0; Wed, 26 Feb 2020 18:46:39 +0100 (CET)
Date:   Wed, 26 Feb 2020 18:46:38 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 12/13] aacraid: use scsi_host_busy_iter() in
 get_num_of_incomplete_fibs()
Message-ID: <20200226174638.GI23141@lst.de>
References: <20200213140422.128382-1-hare@suse.de> <20200213140422.128382-13-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213140422.128382-13-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 13, 2020 at 03:04:21PM +0100, Hannes Reinecke wrote:
> Use the scsi midlayer helper to traverse the number of outstanding
> commands. This also eliminates the last usage for the cmd_list
> functionality so we can drop it.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Acked-by: Balsundar P <balsundar.p@microchip.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
