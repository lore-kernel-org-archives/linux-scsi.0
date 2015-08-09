From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] scsi: storvsc: Fix a bug in copy_from_bounce_buffer()
Date: Sun, 09 Aug 2015 13:25:49 +0200
Message-ID: <1439119549.7315.79.camel@decadent.org.uk>
References: <1438974286.7315.74.camel@decadent.org.uk>
	  <BY2PR0301MB1654A99AC0AD5D52015CA8DCA0710@BY2PR0301MB1654.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vp6E8o6GP5v3/evQaA66"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40247 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932919AbbHILZ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Aug 2015 07:25:58 -0400
In-Reply-To: <BY2PR0301MB1654A99AC0AD5D52015CA8DCA0710@BY2PR0301MB1654.namprd03.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: Long Li <longli@microsoft.com>, linux-scsi <linux-scsi@vger.kernel.org>


--=-vp6E8o6GP5v3/evQaA66
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2015-08-09 at 02:01 +0000, KY Srinivasan wrote:
>=20
> > -----Original Message-----
> > From: KY Srinivasan
> > Sent: Saturday, August 8, 2015 7:55 AM
> > To: 'Ben Hutchings' <ben@decadent.org.uk>
> > Cc: Long Li <longli@microsoft.com>; linux-scsi <linux-scsi@vger.kernel.=
org>
> > Subject: RE: [PATCH] scsi: storvsc: Fix a bug in copy_from_bounce_buffe=
r()
> >=20
> > > -----Original Message-----
> > > From: Ben Hutchings [mailto:ben@decadent.org.uk]
> > > Sent: Friday, August 7, 2015 12:05 PM
> > > To: KY Srinivasan <kys@microsoft.com>
> > > Cc: Long Li <longli@microsoft.com>; linux-scsi <linux-scsi@vger.kerne=
l.org>
> > > Subject: Re: [PATCH] scsi: storvsc: Fix a bug in copy_from_bounce_buf=
fer()
> > >=20
> > > Commit 8de580742fee ("scsi: storvsc: Fix a bug in
> > > copy_from_bounce_buffer()"), actually modified the function
> > > copy_to_bounce_buffer().  Is the commit message wrong, or was the
> > patch
> > > applied to the wrong function?
> > >=20
> > Ben,
> >=20
> > Most likely the message is "misleading". I currently don't have access =
to the
> > source; I will confirm sometime tonight.
>=20
> The commit message is a typo (and is misleading).

Thanks for confirming.

Ben.

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein


--=-vp6E8o6GP5v3/evQaA66
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVcc4vee/yOyVhhEJAQqp/g//Y+JMJBHmC4LXptXKqSAtqeWjgCFmRoOC
fhMSPhxdZNDiPPQXObk2X1zKUKEkSs0mSCVZ7pOKERGKyZ07PFKEi6ziliQ0sopC
pPQUx5s1z1QOLBy1B+daw3C+8QxNn/97SHQpDPYJ4F61wRdKKVKhOWbGEYR/0ra/
Wvt3fsEOI7JQKnxtoNQFRHgv1+968RFc7ULGR8h7mtdr8m80AyGuIY9iXiLwds+V
Pweiy56P8icWqqNGWB35oVS4q6tRd7UO2CHsJR88YOqse2cVctFZTw1OomMwxSRw
oziAGW/6A97yqyDfkKKp/mrp6cY7E/wVYM5OTnbZL1eNuJg3QeHgrIyQbe9E7nM+
dXZsaUOy8oCWkEXjGgTzr+V74n4ADaZpg+HkTxA6sL+EZ4VCiiezhZ1eCOHpKENk
Fj98MvYKk3TUp3ErHQgC6I9QQOxNPbHLakaHMc7r6F6Gasn6jtrBaeOItQO4gBUv
I4vxUPh711qz+SqiKb7kD6WT0+3cNWnrtXEpWhf8SS/INePLJaCI+2bm+fIYwnBk
BWZPOiuEPSjVFY0NN7oBnVn+D9u1GVwwmcH522cGY8MPhbfebND+U1ReZOeR/Nhj
cKpA7whU4oy0DGwLeoOn9+2SDSNwAku+MNs7bpDtD28Z3iDiDAb/LXDIMNVMOwhE
UmBKpN3RIN4=
=pws9
-----END PGP SIGNATURE-----

--=-vp6E8o6GP5v3/evQaA66--
