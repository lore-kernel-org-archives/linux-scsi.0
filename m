From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 0/5] mempool based chained scatterlist alloc/free api
Date: Thu, 24 Mar 2016 11:46:00 -0400
Message-ID: <1458834360.2544.12.camel@HansenPartnership.com>
References: <1458684196-15923-1-git-send-email-mlin@kernel.org>
	 <20160323074012.GA17929@lst.de>
	 <CAF1ivSaxn7KbiLt0ByHoC-EyP-Q0ah33YGNv0rLoO-=sOvia5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43240 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755727AbcCXPqF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Mar 2016 11:46:05 -0400
In-Reply-To: <CAF1ivSaxn7KbiLt0ByHoC-EyP-Q0ah33YGNv0rLoO-=sOvia5w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lin <mlin@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2016-03-24 at 08:09 -0700, Ming Lin wrote:
> On Wed, Mar 23, 2016 at 12:40 AM, Christoph Hellwig <hch@lst.de>
> wrote:
> > On Tue, Mar 22, 2016 at 03:03:11PM -0700, Ming Lin wrote:
> > > From: Ming Lin <ming.l@ssi.samsung.com>
> > >=20
> > > The fist 4 patches make the SG related
> > > definitions/structs/functions
> > > in SCSI code generic and the last patch move it to lib/sg_pool.c.
> > >=20
> > > I still keep the macro "SG_MEMPOOL_NR" since it's used in 3
> > > places.
> >=20
> > I don't =D1=95ee the point, but I'm not going to block the series o=
ver
> > it either.
> >=20
> > The new series looks really nice to me!
> >=20
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
>=20
> Hi James,
>=20
> This series touches several sub-systems.
> What's the best way to merge it?

It has a minor intrusion into=20

 drivers/ata/pata_icside.c           |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c |   4 +-
 drivers/usb/storage/scsiglue.c      |   2 +-

Apart from that, it's all SCSI, so the SCSI tree would seem to be the
best one.

James

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
