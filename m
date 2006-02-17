From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: [Bugme-new] [Bug 6080] New: New Megaraid Module Problem
Date: Fri, 17 Feb 2006 10:24:44 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C265142096@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56209 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750836AbWBQRYv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Feb 2006 12:24:51 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, "Kolli, Neela" <Neela.Kolli@engenio.com>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

Hi,
On Friday, February 17, 2006 4:22 AM Hannes Reinecke wrote:
> Isn't the megaraid i960 based? Then it might well be that it collides
> with the generic i2o modules which are loaded previously by default.
>=20
> So check whether any of those i2o modules are loaded and unload them
> before continuing.
Just to make sure.
Is 'generic I2O module' I2O OSM?
If so, I2O OSM should not claim the controller.
The controller has I2O mode flag turned off by default.
Please add comment for anything missing, here.



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]=20
> Sent: Friday, February 17, 2006 4:22 AM
> To: Ju, Seokmann
> Cc: Ju, Seokmann; Andrew Morton; Kolli, Neela;=20
> linux-scsi@vger.kernel.org; bugme-daemon@kernel-bugs.osdl.org
> Subject: Re: [Bugme-new] [Bug 6080] New: New Megaraid Module Problem
>=20
> Ju, Seokmann wrote:
> > Hi,
> > On Thursday, February 16, 2006 9:36 AM Seokmann Ju wrote:
> >> I've verified the 'megaraid' driver that is available on GIT=20
> >> kernel (2.6.16-rc2).
> >> The driver 'megaraid.ko' is working fine on the kernel.
> >> However, I'm working on another issue related to this driver.=20
> >> On SuSE SLES 10 (kernel 2.6.16-rc1-git3-7), the kernel claims=20
> >> that the driver has loaded, but it won't detect the=20
> >> controller nor scan the drives.
> >> Both kernel (GIT kernel and SLES10) have same 'megaraid' driver.
> >> I'll update here for any progress on it.
> > I've also test 'megaraid.ko' driver on latest GIT kernel 2.6.16-rc3=
=2E
> > The driver works fine as expected. I've ran the basic I/O=20
> test after file system created on the device.
> >=20
> Isn't the megaraid i960 based? Then it might well be that it collides
> with the generic i2o modules which are loaded previously by default.
>=20
> So check whether any of those i2o modules are loaded and unload them
> before continuing.
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke			hare@suse.de
> SuSE Linux Products GmbH		S390 & zSeries
> Maxfeldstra=DFe 5				+49 911 74053 688
> 90409 N=FCrnberg				http://www.suse.de
>=20
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
