From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Host drivers and conversion of SCSI to the driver model
Date: Sun, 6 Jul 2003 17:04:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030706170438.A5690@infradead.org>
References: <20030627110259.A3751@infradead.org> <Pine.LNX.4.44L0.0307031110400.4852-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from carisma.slowglass.com ([195.224.96.167]:26628 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262366AbTGFPuI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Jul 2003 11:50:08 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0307031110400.4852-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Thu, Jul 03, 2003 at 11:15:32AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Jul 03, 2003 at 11:15:32AM -0400, Alan Stern wrote:
> > If you think a bit about this this is what's really needed - even with
> > your notification you'd still have module unload races.  With the above
> > fix you can just free your private data in your ->remove method
> > (or wherever you want) after you marked the struct device / class_device
> > gone and be sure it'll never be used again.
> 
> How will this interact with the module reference-counting just added to 
> sysfs by Greg K-H?  Maybe with that new feature, none of this will be 
> needed.

The module refounting helps with the attribute vs unload races but
nothing else.

