From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: merge megaraid 2.20.x in kernel 2.6?
Date: Tue, 17 Aug 2004 13:58:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC96A@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60310 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S268362AbUHQR73 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 13:59:29 -0400
List-Id: linux-scsi@vger.kernel.org
To: "'arjanv@redhat.com'" <arjanv@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, "Mukker, Atul" <Atulm@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Arjan,

It will be :-) but the decision should not be made in a haste since two
other subsystems also use the same pending queue structure, the common
management module and the upcoming /sysfs. James idea of pushing those
packets to the mid-layer queues hasn't gotten much exposure yet. IMHO, that
isn't very clean. The respective sub-system should re-try in case the host
is busy.

There is another change pending, as suggested by Matt and Christoph,
function re-ordering. This also is pushed for post-merge since otherwise it
will be difficult to get it at all in the kernel. Remember, the first
submission was made sometime in May, when the stable kernel was 2.6!

Thanks
-Atul

> -----Original Message-----
> From: Arjan van de Ven [mailto:arjanv@redhat.com]
> Sent: Tuesday, August 17, 2004 1:07 PM
> To: Matt Domsch
> Cc: Christoph Hellwig; James Bottomley; atulm@lsil.com; SCSI Mailing
> List
> Subject: Re: merge megaraid 2.20.x in kernel 2.6?
> 
> 
> On Tue, 2004-08-17 at 18:51, Matt Domsch wrote:
> > On Tue, Aug 17, 2004 at 05:47:55PM +0100, Christoph Hellwig wrote:
> > > Does this driver release have the queue removal James wanted?
> > 
> > Not yet, that was one of the changes Atul requested he be allowed to
> > make post-merge.
> 
> if that was a few weeks ago.. that should be completed by now, right ?
> I fear that when we merge this new driver we'll never get the queueing
> removed once it's let in.
> 
> 
