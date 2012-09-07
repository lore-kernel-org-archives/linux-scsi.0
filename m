From: Thomas Schwinge <thomas@codesourcery.com>
Subject: Re: Linux kernel crash (3.2.0-2-amd64) when trying to play audio CD
Date: Fri, 7 Sep 2012 11:14:33 +0200
Message-ID: <877gs69oue.fsf@schwinge.name>
References: <87obojef7t.fsf@schwinge.name> <20120616181008.GB20623@liondog.tnic> <87ehpddw9k.fsf@schwinge.name> <20120618142900.GA9710@aftab.osrc.amd.com> <87sjdsd64r.fsf@schwinge.name> <20120618155141.GF8378@aftab.osrc.amd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg=pgp-sha1;
	protocol="application/pgp-signature"
Return-path: <bounce-debian-kernel=glddk-debian-kernel=m.gmane.org@lists.debian.org>
In-Reply-To: <20120618155141.GF8378@aftab.osrc.amd.com>
Resent-Message-ID: <hHDsWUglJyN.A.Zw.jsbSQB@bendel>
List-URL: <http://lists.debian.org/debian-kernel/>
List-Post: <mailto:debian-kernel@lists.debian.org>
List-Help: <mailto:debian-kernel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-kernel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-kernel-request@lists.debian.org?subject=unsubscribe>
To: Borislav Petkov <bp@amd64.org>
Cc: Borislav Petkov <bp@alien8.de>, debian-kernel@lists.debian.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Borislav!

I'm sorry for the late answer.


On Mon, 18 Jun 2012 17:51:41 +0200, Borislav Petkov <bp@amd64.org> wrote:
> On Mon, Jun 18, 2012 at 04:52:36PM +0200, Thomas Schwinge wrote:
> > > Ok, can you do the following:
> > >=20
> > > $ setpci -s 18.0 0x68.l
> >=20
> >     $ sudo setpci -s 18.0 0x68.l
> >     0f00cc0f
> >=20
> > > $ rdmsr 0xc001001f
> >=20
> >     $ sudo modprobe msr
> >     $ sudo rdmsr 0xc001001f
> >     8
>=20
> Ok, this is a BIOS bug - we have a recommendation about what the BIOS
> should do but yours doesn't do it. Are you sure you're using the latest
> BIOS for your motherboard?
>=20
> Can you check for updates and if you get a newer version, can you update
> your BIOS and do the two commands above?

I have now finally been able to check this, and yes, I'm already using
the latest version of the BIOS, which is Phoenix cME FirstBIOS Desktop
Pro version 5.00 R1.07.2264.A1 (a.k.a.  5.00.1.07, 25.04.2006) for
Fujitsu Siemens Esprimo E5600, mainboard D2264-A1, CPU AMD Sempron 3000+.

> If there's no newer BIOS, we can try applying the workaround at boot in
> an init script to fix your issue.

How'd that be done?


Gr=C3=BC=C3=9Fe,
 Thomas

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJQSbr5AAoJENuKOtuXzphJ3tcH/imLh1StPoUZgiSkovI2c69n
olKgp+srGs3kZfuWloQeSD+3e8czKXA8/UQEU0eAZXuwKJkXjjurXlkzj9C1spWv
KGQ1uwtg7OavstDFagK+LM60wi7JM3H35uKOG4DA/vFSOVCa7lL7az3GZleTz8Fp
eLFipP7gJrqIUqmUsg7NFJhzxZ943c7ToEPLSUdVbrzLtWD6eKfkr9wuMidcONYg
TCgHw8xnEKdovt9vMuoh3oNCqvXnWLYoObkyQuWyPvADM9B8uulkQ4IIbkemCPuc
YaxJf8nxusLvf1/rGTaKz4Aq0+vps20327O8GGAnlLUcdAqN5au9wtHkVdEuk+8=
=EnNu
-----END PGP SIGNATURE-----
--=-=-=--
