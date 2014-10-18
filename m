From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vmw_pvscsi: fixup tagging
Date: Sat, 18 Oct 2014 08:13:29 -0700
Message-ID: <20141018151329.GB30355@infradead.org>
References: <1412234501-78199-1-git-send-email-hare@suse.de>
 <20141017131651.GD16538@infradead.org>
 <41c186a1dcd04732a87f8bc47336a5d7@EX13-MBX-025.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56439 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaJRPNf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Oct 2014 11:13:35 -0400
Content-Disposition: inline
In-Reply-To: <41c186a1dcd04732a87f8bc47336a5d7@EX13-MBX-025.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arvind Kumar <arvindkumar@vmware.com>
Cc: Hannes Reinecke <hare@suse.de>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Oct 17, 2014 at 06:34:48PM +0000, Arvind Kumar wrote:
> Hi Christoph,
> 
> Thanks for the change. Sorry for the delay. The change looks fine to me. I just have a question.
> 
> The comment in include/scsi/scsi_cmnd.h says:
> 
> struct scsi_cmnd {
> ...
>              unsigned char tag; /* SCSI-II queued command tag */
> }
> 
> Is that comment not right? Should we update that too?

The comment looks very confusing and I'm fine with a patch that just
removes the comment.  That being said Hannes has patches to remove the
whole field which I'd like to merge once he fixes up the remaining
issues, so it might not worth the effort.

