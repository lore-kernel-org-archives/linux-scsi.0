From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 01/20] [SCSI] mpt3sas: Added Combined Reply Queue feature
 to extend up-to 96 MSIX vector support
Date: Fri, 19 Jun 2015 11:55:16 +0200
Message-ID: <20150619095516.GD7462@c203.arch.suse.de>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <1434102153-38581-2-git-send-email-Sreekanth.Reddy@avagotech.com>
 <20150612110915.GB2812@c203.arch.suse.de>
 <CAK=zhgqDYpNQvUVmjMDxhVrGWBw6zzidewPg3fe1cUSdpRnjqw@mail.gmail.com>
 <CAK=zhgpqRNE00ygoC3J-QKJwUPeYW=2j0TAcz4Q0t3ie7uSfOw@mail.gmail.com>
 <20150619091443.GB7462@c203.arch.suse.de>
 <CAK=zhgpd3O8UkX51AUdqmJ9cWujfoq-SkQScBkywX7Z0JDRkwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbbFSJzT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 05:55:19 -0400
Content-Disposition: inline
In-Reply-To: <CAK=zhgpd3O8UkX51AUdqmJ9cWujfoq-SkQScBkywX7Z0JDRkwg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, Jun 19, 2015 at 02:51:00PM +0530, Sreekanth Reddy wrote:
> On Fri, Jun 19, 2015 at 2:44 PM, Johannes Thumshirn <jthumshirn@suse.=
de> wrote:
> > On Thu, Jun 18, 2015 at 03:27:26PM +0530, Sreekanth Reddy wrote:
> >> Hi,
> >>
> >> Any other review comments on this patch. please let us known if an=
y
> >> changes are required.
> >>
> >> Thanks,
> >> Sreekanth
> >>
> >
> > Have you sent a follow up on this I may have missed?
> >
> >> On Fri, Jun 12, 2015 at 4:46 PM, Sreekanth Reddy
> >> <sreekanth.reddy@avagotech.com> wrote:
> >> > Thanks Johannes, we will take care of this point in our current
> >> > on-development mpt2sas/mpt3sas merging activity.
> >> >>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scs=
i/mpt3sas/mpt3sas_base.c
> >
> > [...]
> >
> >> >>> index 14a781b..c13a365 100644
> >> >>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> >> >>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> >> >>> @@ -83,7 +83,7 @@ static int msix_disable =3D -1;
> >> >>>  module_param(msix_disable, int, 0);
> >> >>>  MODULE_PARM_DESC(msix_disable, " disable msix routed interrup=
ts (default=3D0)");
> >> >>>
> >> >>> -static int max_msix_vectors =3D 8;
> >> >>> +static int max_msix_vectors =3D -1;
> >> >>>  module_param(max_msix_vectors, int, 0);
> >> >>>  MODULE_PARM_DESC(max_msix_vectors,
> >> >>>       " max msix vectors - (default=3D8)");
> >                                  ^^^^^^^^^^^
> >> >>
> >> >> When changing the default value, please also update the descrip=
tion reflecting
> >> >> this change.
>=20
> Johannes, I didn't notice this previously, I will post next version o=
f
> this patch by updating the module parameter description

No problem :-)

>=20
> Thanks,
> Sreekanth
> >> >>
> >
> > Thanks
> >
> > --
> > Johannes Thumshirn                                       Storage
> > jthumshirn@suse.de                             +49 911 74053 689
> > SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> > GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> > HRB 21284 (AG N=FCrnberg)
>=20
>=20
>=20
> --=20
>=20
> Regards,
> Sreekanth

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
