From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] remove ->emulated from host template
Date: Thu, 1 Apr 2004 06:00:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040401060039.A16290@infradead.org>
References: <406B5BC7.2080309@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:59664 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262285AbUDAFAo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 00:00:44 -0500
Content-Disposition: inline
In-Reply-To: <406B5BC7.2080309@pobox.com>; from jgarzik@pobox.com on Wed, Mar 31, 2004 at 07:01:11PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Mar 31, 2004 at 07:01:11PM -0500, Jeff Garzik wrote:
> 
> I think the comment and usage in drivers/block/scsi_ioctl.c says it all, 
> but just in case...
> 
> This ->emulated exists solely to export an unneeded distinction to 
> userspace.  As you can see from sg_emulated_host() in scsi_ioctl.c, the 
> value in today's 2.6.x kernels is pretty much completely meaningless.

I agree with this change, but 2.6.x is the wrong place for it.  Please
resubmit for early 2.7.

