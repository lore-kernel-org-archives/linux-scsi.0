From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/1] ipr: Fix for adapter shutdown issue
Date: Wed, 15 Jun 2005 09:01:47 -0700
Message-ID: <20050615160147.GA27966@suse.de>
References: <200506151515.j5FFFNQA020480@d01av01.pok.ibm.com> <20050615151742.GA24061@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lyle.provo.novell.com ([137.65.81.174]:64683 "EHLO
	lyle.provo.novell.com") by vger.kernel.org with ESMTP
	id S261197AbVFOQCF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 12:02:05 -0400
Content-Disposition: inline
In-Reply-To: <20050615151742.GA24061@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: brking@us.ibm.com, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, haren@us.ibm.com

On Wed, Jun 15, 2005 at 04:17:42PM +0100, Christoph Hellwig wrote:
> On Wed, Jun 15, 2005 at 10:15:22AM -0500, brking@us.ibm.com wrote:
> > 
> > 
> > James,
> > Haren found this in some recent kexec testing. Without this fix, the
> > ipr adapter's write cache never gets flushed. I'd like to see this
> > pushed into 2.6.12 if possible.
> 
> Umm, there's tons of other drivers doing this. Greg, please revert
> your pci-layer ->shutdown thing for 2.6.12 and make convert all drivers
> when re-introducing it.  Or even better make sure it doesn't break
> drivers setting ->shutdown themselves.

I'm sorry, what pci-layer ->shutdown thing?  Have a pointer to the patch
in question that people are having problems with?

thanks,

greg k-h
