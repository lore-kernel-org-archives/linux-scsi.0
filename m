From: "Smart, James" <James.Smart@Emulex.Com>
Subject: RE: [PATCH] dead code and missing statics in lpfc
Date: Thu, 10 Jun 2004 10:33:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F9495@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:9908 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S261347AbUFJOeC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2004 10:34:02 -0400
List-Id: linux-scsi@vger.kernel.org
To: "'arjanv@redhat.com'" <arjanv@redhat.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Arjan van de Ven [mailto:arjanv@redhat.com]
> Sent: Thursday, June 10, 2004 9:37 AM
> To: Smart, James
> Cc: 'Christoph Hellwig'; linux-scsi@vger.kernel.org
> Subject: RE: [PATCH] dead code and missing statics in lpfc
> 
> 
> 
> 
> > I am simply making a point that : 
> > I think it's too much to demand that all external entry 
> points be removed.
> 
> is it? Christoph has a point in that the users of such points 
> surely can
> be added to the kernel too? Maybe we can even make some of those more
> generic and have a driver testing/hardening framework in the scsi
> midlayer.

I agree with the underlying idea. Make it available, and select the best
parts for a common implementation.  For diagnostics and testing, some of the
framework may be interesting, but the content will be very driver and
hardware-centric. Many would consider including this content, for no
"standard" purpose, is another way to add crud to the driver.  Making
symbols available was a means to avoiding this latter issue.

> 
> However I must say that just some hooks for "invisible" stuff that
> significantly crap up a driver are a mistake in my opinion 
> and should be
> removed. Quite often such things stand in the way of real cleanups and
> restructuring for example.

I respect this opinion. And if this is the consensus, there will be no
problems in following it.


-- James S

