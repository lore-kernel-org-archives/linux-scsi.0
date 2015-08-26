From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [scsi 5/7 RESEND] scsi_debug: schedule_resp fix input variable
 check
Date: Wed, 26 Aug 2015 16:38:00 -0700
Message-ID: <1440632280.2196.94.camel@HansenPartnership.com>
References: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
	 <1438091666-18113-5-git-send-email-tomas.winkler@intel.com>
	 <1440532371.23183.81.camel@localhost.localdomain>
	 <5B8DA87D05A7694D9FA63FD143655C1B3D42E9D0@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B3D42E9D0@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "emilne@redhat.com" <emilne@redhat.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-08-25 at 21:03 +0000, Winkler, Tomas wrote:
>=20
> > > +	/* this should never happen */
> > > +	if (WARN_ON(!cmnd))
> > > +		return SCSI_MLQUEUE_HOST_BUSY;
> > >
> > > -	if (NULL =3D=3D cmnd || NULL =3D=3D devip) {
> > > -		pr_warn("called with NULL cmnd or devip pointer\n");
> > > +	if (NULL =3D=3D devip) {
> > > +		pr_warn("called devip =3D=3D NULL\n");
> > >  		/* no particularly good error to report back */
> > >  		return SCSI_MLQUEUE_HOST_BUSY;
> > >  	}
> >=20
> > Please refer to the patch I just posted, we can't return _HOST_BUSY=
 here
> > if devip =3D=3D NULL.  I posted a fix against the current "misc" br=
anch as
> > I don't see this patch applied, let me know if I need to update it.
>=20
>=20
> I'm just not sure why the patches are not merged or even rejected.

Because ideally I want a Maintainer ack.  That's Doug Gilbert.

> I'm submitting patches to the Linux kernel for more than 10 years to
> various trees and  I can agree that these are not some  urgent fixes,
> but  this is the first time my effort is ignored for such long time b=
y
> the maintainer.=20

Well, OK, I trust martin, I'll override the lack of Maintainer ack if
you fix as Ewan suggests.

James


> Thanks
> Tomas
>=20
> NrybX=C7=A7v^)=DE=BA{.n+{"{ay=1D=CA=87=DA=99,j=07fhz=1Ew=0Cj:+vwjm=07=
zZ+=DD=A2j"!
