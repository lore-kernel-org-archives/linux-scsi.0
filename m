From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: some PCMCIA SCSI drivers can be built *only* as modules
Date: Fri, 30 Mar 2007 16:48:11 -0400
Message-ID: <20070330204811.GC11637@isilmar.linta.de>
References: <Pine.LNX.4.64.0703250916090.22484@CPE00045a9c397f-CM001225dbafb6> <4607CA5A.4040906@s5r6.in-berlin.de> <20070326200257.GA28622@infradead.org> <1174941347.3549.41.camel@mulgrave.il.steeleye.com> <20070326203824.GA1430@infradead.org> <1174943213.3549.53.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isilmar.linta.de ([213.239.214.66]:35180 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753618AbXC3Uyy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Mar 2007 16:54:54 -0400
Content-Disposition: inline
In-Reply-To: <1174943213.3549.53.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Robert P. J. Day" <rpjday@mindspring.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Mon, Mar 26, 2007 at 04:06:53PM -0500, James Bottomley wrote:
> On Mon, 2007-03-26 at 21:38 +0100, Christoph Hellwig wrote:
> > On Mon, Mar 26, 2007 at 03:35:47PM -0500, James Bottomley wrote:
> > > I agree the non-legacy (CardBus and beyond) ones can be built in.  I
> > > thought the legacy 8 and 16 bit type I and II still had to be modular
> > > because they still need setting up.
> > 
> > nope.  While I don't have a pcmcia scsi card my 16 bit pcmcia wireless
> > cards work perfectly fine without any previous setup.
> 
> OK ... I had the opposite experience ... A ZoomAir 802.11b card wasn't
> working because I'd accidentally config'd it non-modular.  However, if
> Dominik confirms it's all supposed to work non-modular.

PCMCIA card drivers should (famous last words) work just fine if built as
modules. They may not be bound to devices, depending on the arch and 
system, until userspace tools have run, but this is independent of modular
or built-in drivers. So a full ACK on this.

Thanks,

Dominik
