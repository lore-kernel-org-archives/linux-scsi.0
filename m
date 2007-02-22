From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [Patch 2/2] cciss: add shutdown support (replaces reboot notifier)
Date: Thu, 22 Feb 2007 15:56:11 -0600
Message-ID: <20070222215611.GB14162@beardog.cca.cpqcorp.net>
References: <20070222213845.GA14162@beardog.cca.cpqcorp.net> <20070222214502.GA19670@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:58855 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbXBVV4O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Feb 2007 16:56:14 -0500
Content-Disposition: inline
In-Reply-To: <20070222214502.GA19670@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, akpm@osdl.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com

On Thu, Feb 22, 2007 at 09:45:02PM +0000, Christoph Hellwig wrote:
> On Thu, Feb 22, 2007 at 03:38:45PM -0600, Mike Miller (OS Dev) wrote:
> > Patch 2/2
> > 
> > This adds support for struct pci_driver shutdown and negates the previous NAK'ed
> > reboot_notifier patch. It's much easier, wish I had know about this before. Thanks to
> > Christoph for pointing this out.
> 
> Just sondering, where should we have put information about this so driver
> writers/maintainers like you would have found it easily?
> 
Excellent question. I wish I had a good answer. It's pretty difficult to monitor
everything going on, especially when I also have to consider HP's schedule and those
of our partners. 

-- mikem
