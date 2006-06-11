From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] remove RQ_SCSI_* flags
Date: Sun, 11 Jun 2006 20:58:48 +0200
Message-ID: <20060611185848.GE13556@suse.de>
References: <20060610163719.GA12421@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:12398 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1750791AbWFKS6z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Jun 2006 14:58:55 -0400
Content-Disposition: inline
In-Reply-To: <20060610163719.GA12421@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Sat, Jun 10 2006, Christoph Hellwig wrote:
> The RQ_SCSI_* flags are a vestiage of a long past history.  The EH code
> still sets them but we never make use of that information.  The other
> users is pluto.c which never had a chance to work but needs to be kept
> compiling to keep Davem happy, so copy over the definition there.
> 
> We could probably get rid of RQ_ACTIVE/RQ_INACTIVE aswell with some
> work, there's only two more or less bogus looking uses in ubd and scsi.

Wonderful! Please continue with the rest of the rq_status usage when you
have the time, it's been on the to-kill list since 2001.

-- 
Jens Axboe

