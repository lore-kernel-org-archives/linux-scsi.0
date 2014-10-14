From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SG_SCSI_RESET ioctl reset escalation
Date: Tue, 14 Oct 2014 04:33:55 -0700
Message-ID: <20141014113355.GA3926@infradead.org>
References: <94D0CD8314A33A4D9D801C0FE68B402958CEF205@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56655 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbaJNLeF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Oct 2014 07:34:05 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958CEF205@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Don Brace (PMC)" <Don.Brace@pmcs.com>, "Scales, Webb" <webb.scales@hp.com>

On Mon, Oct 13, 2014 at 10:24:01PM +0000, Elliott, Robert (Server Storage) wrote:
> Those stronger reset levels affect multiple devices,
> which may or may not be desired.
> 
> sg-reset includes a --no-esc option to ask the kernel
> to not escalate resets, based on a February 2013 thread,
> but the matching kernel changes were never merged.
> 
> Original issue:
> http://marc.info/?l=linux-scsi&m=136000904311597&w=2
> 
> Suggested fix:
> http://marc.info/?l=linux-scsi&m=136095718729372&w=2
> 
> Could that fix be revived?

I'd be happy to merge it if Doug can resend it against a current
tree, preferably my scsi-ioctl branch from the previous thread.

While we're at it: Doug, can you replace the addition of the constants
in the switch with a logical or - that's the more common kernel style.
