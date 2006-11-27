From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Disable SCSI-Reservation at the driver level ?
Date: Mon, 27 Nov 2006 17:18:12 +0000
Message-ID: <20061127171812.GA9185@infradead.org>
References: <1456266874@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:14817 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1758451AbWK0RSN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Nov 2006 12:18:13 -0500
Content-Disposition: inline
In-Reply-To: <1456266874@web.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devzero@web.de
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Mon, Nov 27, 2006 at 10:45:42AM +0100, devzero@web.de wrote:
> > And more.  It's in fact one of the most blatant violations of the
> > Linux 2.4 kernel copyrights.  Don't expect support if you use such
> > an illegal product.
> 
> really?
> this is the first time i hear that ESX is an "illegal" product from the point of view of the kernel community.
> afaik, the esx kernel (vmnix) is a completely different product and for example, the source of the linux drivers they have modified to run under ESX are made available for download, as GPL tells them to do.
> 
> what`s the problem here?

It's a modified linux kernel with hooks for a big binary module that takes
over part of the control.  It's rather hard to argue that it's not a derived
work.  Especially as they reuse various I/O subsystem of the kernel
that has been parasited.

> can you provide a link to some thread where this has been discussed?

I don't think so.

> something to be resolved with the help of gpl-violations.org ?

I haven't found any evidence that they are using enough code that
gpl-violations.org has the right to defend.
