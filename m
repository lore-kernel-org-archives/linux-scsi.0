From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] nvmet_fc: add defer_req callback for deferment of
 cmd buffer return
Date: Wed, 16 Aug 2017 00:53:43 -0700
Message-ID: <20170816075343.GA30644@infradead.org>
References: <20170801221240.31723-1-jsmart2021@gmail.com>
 <20170801221240.31723-2-jsmart2021@gmail.com>
 <20170810090604.65ccmgooqzilhkjq@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45767 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751452AbdHPHxo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 03:53:44 -0400
Content-Disposition: inline
In-Reply-To: <20170810090604.65ccmgooqzilhkjq@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: James Smart <james.smart@broadcom.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Thu, Aug 10, 2017 at 11:06:04AM +0200, Christoph Hellwig wrote:
> > @@ -463,9 +472,9 @@ static struct nvmet_fc_fcp_iod *
> >  nvmet_fc_alloc_fcp_iod(struct nvmet_fc_tgt_queue *queue)
> >  {
> >  	static struct nvmet_fc_fcp_iod *fod;
> 
> This isn't new, but is this really supposed to be a static variable,
> that is all instances of this code sharing it use the same?
> 
> After a short code inspection this looks like a nasty bug to me.

James, can you look into this asap?
