From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Usb in 2.6 breaks proc
Date: Thu, 7 Aug 2003 17:10:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030807171018.D31799@one-eyed-alien.net>
References: <20030807191740.C27716@devserv.devel.redhat.com> <20030807234932.GA13780@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="1sNVjLsmu1MXqwQ/"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:13321 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S271152AbTHHAKf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 20:10:35 -0400
Content-Disposition: inline
In-Reply-To: <20030807234932.GA13780@kroah.com>; from greg@kroah.com on Thu, Aug 07, 2003 at 04:49:32PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>, linux-usb-devel@lists.sourceforge.net, warren@togami.com, linux-scsi@vger.kernel.org


--1sNVjLsmu1MXqwQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

It is a known SCSI issue.  I'm told that there are pending patches to
address this.

Matt

On Thu, Aug 07, 2003 at 04:49:32PM -0700, Greg KH wrote:
> On Thu, Aug 07, 2003 at 07:17:40PM -0400, Pete Zaitcev wrote:
> > Greg, Matt & folks:
> >=20
> > There was a tangential report from one of our users that /proc
> > seems to get corrupt when usb-storage is rmmod-ed and inserted again.
> >=20
> > Kernel 2.6.0-0.test2.1.29 (Arjan's -test2 based RPM).
> >=20
> > Problem looks like this:
> >=20
> > [root@laptop scsi]# pwd
> > /proc/scsi
> > [root@laptop scsi]# find
> > .
> > ./usb-storage
> > ./usb-storage/2
> > ./usb-storage
> > ./usb-storage/2
> > ./device_info
> > ./scsi
>=20
> Ouch, could this be a scsi issue?  I know a bunch of patches are pending
> to get into Linus's tree with regards to scsi reference counting and
> such.
>=20
> thanks,
>=20
> greg k-h
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

We can customize our colonels.
					-- Tux
User Friendly, 12/1/1998

--1sNVjLsmu1MXqwQ/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/MuppIjReC7bSPZARAki8AJwLgcSj69ugk1F0OIm6BmOvuSoMqQCglCqd
EqgcmPB1Yaz05gEN5i17/kg=
=Y/Nf
-----END PGP SIGNATURE-----

--1sNVjLsmu1MXqwQ/--
