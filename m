From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH] hpsa: switch to pci_alloc_irq_vectors
Date: Wed, 9 Nov 2016 21:30:46 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D193B084021@avsrvexchmbx1.microsemi.net>
References: <1478589145-74280-1-git-send-email-hare@suse.de>
 <4993A297653ECB4581FA5C3C31323D193B083C61@avsrvexchmbx1.microsemi.net>
 <20161109153628.GA23452@lst.de>
 <dc7c9c33-7a88-bd4f-c330-16c8f447e4cc@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0057.outbound.protection.outlook.com ([104.47.34.57]:17439
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751618AbcKIVau (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Nov 2016 16:30:50 -0500
In-Reply-To: <dc7c9c33-7a88-bd4f-c330-16c8f447e4cc@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>


> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Wednesday, November 09, 2016 9:45 AM
> To: Christoph Hellwig; Don Brace
> Cc: Martin K. Petersen; James Bottomley; linux-scsi@vger.kernel.org; Hann=
es
> Reinecke
> Subject: Re: [PATCH] hpsa: switch to pci_alloc_irq_vectors
>=20
> EXTERNAL EMAIL
>=20
>=20
> On 11/09/2016 04:36 PM, Christoph Hellwig wrote:
> > On Wed, Nov 09, 2016 at 03:32:48PM +0000, Don Brace wrote:
> >> Do we need to add an entry for map_queues?
> >
> > The existing driver only supports a single submission queue.
> > If some of the devices support more than one submission queue
> > we could enhance the driver to support it, but we'd need docs
> > and hardware.
> >
> Hardware is not an issue :-)
>=20
> However, I'm still curious about the layout of the queues.
> Are all queues (in performant mode) identical and can we use them for
> parallel submission? Or do we have to treat them differently?\

All of the submission queues are identical.

> (There were some rumours that it actually uses the queues for different
> I/O sizes ...)

This is an untrue rumor. :)

Thanks,
Don Brace

ESC - Smart Storage
Microsemi Corporation



>=20
> Once that is cleared up it shouldn't be too hard moving to full
> multiqueue support.
> (If we have identical queues, that is :-)
>=20
> Cheers,
>=20
> Hannes
> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
