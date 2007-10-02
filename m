From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 3/5] add sg segment limitation info to device structure
Date: Tue, 2 Oct 2007 09:25:34 -0600
Message-ID: <20071002152534.GT12049@parisc-linux.org>
References: <20070926160558.GA10819@suse.de> <1191281770.3530.24.camel@localhost.localdomain> <20071002013902.GP12049@parisc-linux.org> <20071002042248.GA23399@suse.de> <1191336311.3530.59.camel@localhost.localdomain> <3ae72650710020802r75cc2e39h2f1e7ee1e0a17efb@mail.gmail.com> <1191337528.3530.74.camel@localhost.localdomain> <1191337830.4093.19.camel@lov.localdomain> <1191338072.3530.77.camel@localhost.localdomain> <3ae72650710020823j17219ab5u6c2aefe491884ca6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59130 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbXJBPZg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 11:25:36 -0400
Content-Disposition: inline
In-Reply-To: <3ae72650710020823j17219ab5u6c2aefe491884ca6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Greg KH <gregkh@suse.de>, FUJITA Tomonori <tomof@acm.org>, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Tue, Oct 02, 2007 at 05:23:39PM +0200, Kay Sievers wrote:
> Just looking at the number of devices, it seems that allocating it
> dynamically would be the better deal. We allocate the name of every
> kobject dynamically today, so I guess it's fine to do that with the
> DMA data too.

But we don't need to allocate it dynamically.  We can embed it in the
pci_dev, eisa_dev, zorro_dev, mca_dev and parisc_device.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
