From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 3/5] add sg segment limitation info to device structure
Date: Tue, 2 Oct 2007 09:44:13 -0700
Message-ID: <20071002164413.GA12571@suse.de>
References: <1191281770.3530.24.camel@localhost.localdomain> <20071002013902.GP12049@parisc-linux.org> <20071002042248.GA23399@suse.de> <1191336311.3530.59.camel@localhost.localdomain> <3ae72650710020802r75cc2e39h2f1e7ee1e0a17efb@mail.gmail.com> <1191337528.3530.74.camel@localhost.localdomain> <1191337830.4093.19.camel@lov.localdomain> <1191338072.3530.77.camel@localhost.localdomain> <3ae72650710020823j17219ab5u6c2aefe491884ca6@mail.gmail.com> <20071002152534.GT12049@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:48269 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbXJBQta (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 12:49:30 -0400
Content-Disposition: inline
In-Reply-To: <20071002152534.GT12049@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@steeleye.com>, FUJITA Tomonori <tomof@acm.org>, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Tue, Oct 02, 2007 at 09:25:34AM -0600, Matthew Wilcox wrote:
> On Tue, Oct 02, 2007 at 05:23:39PM +0200, Kay Sievers wrote:
> > Just looking at the number of devices, it seems that allocating it
> > dynamically would be the better deal. We allocate the name of every
> > kobject dynamically today, so I guess it's fine to do that with the
> > DMA data too.
> 
> But we don't need to allocate it dynamically.  We can embed it in the
> pci_dev, eisa_dev, zorro_dev, mca_dev and parisc_device.

But then you run into the issue that James pointed out originally.

Anyway, I don't care which, let's see some patches :)

thanks,

greg k-h
