From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 3/3] smartpqi: switch to pci_alloc_irq_vectors
Date: Mon, 31 Oct 2016 19:32:41 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D193B08010E@avsrvexchmbx1.microsemi.net>
References: <1476521241-32765-1-git-send-email-hch@lst.de>
 <1476521241-32765-4-git-send-email-hch@lst.de>
 <20161017073428.27xzw6du4j3r4qro@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0088.outbound.protection.outlook.com ([104.47.32.88]:28928
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S946259AbcJaUG3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Oct 2016 16:06:29 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

> -----Original Message-----
> From: Don Brace
> Sent: Monday, October 17, 2016 8:45 AM
> To: 'Johannes Thumshirn'; Christoph Hellwig
> Cc: martin.petersen@oracle.com; axboe@kernel.dk; linux-
> scsi@vger.kernel.org; linux-block@vger.kernel.org
> Subject: RE: [PATCH 3/3] smartpqi: switch to pci_alloc_irq_vectors
>=20
>=20
> > -----Original Message-----
> > From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> > Sent: Monday, October 17, 2016 2:34 AM
> > To: Christoph Hellwig
> > Cc: martin.petersen@oracle.com; Don Brace; axboe@kernel.dk; linux-
> > scsi@vger.kernel.org; linux-block@vger.kernel.org
> > Subject: Re: [PATCH 3/3] smartpqi: switch to pci_alloc_irq_vectors
> >
> > EXTERNAL EMAIL
> >
> >
> > On Sat, Oct 15, 2016 at 10:47:21AM +0200, Christoph Hellwig wrote:
> > > Which cleans up a lot of the MSI-X handling, and allows us to use the
> > > PCI IRQ layer provided vector mapping, which we can then expose to bl=
k-
> > mq.
> > >
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> >
> > Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> > --
> > Johannes Thumshirn                                          Storage
> > jthumshirn@suse.de                                +49 911 74053 689
> > SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> > GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> > HRB 21284 (AG N=FCrnberg)
> > Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
>=20
> Acked-by: Don Brace <don.brace@microsemi.com>

Tested-by: Don Brace <don.brace@microsemi.com>
