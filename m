From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 26 Mar 2010 12:27:57 -0700
Message-ID: <20100326192757.GA1187@one-eyed-alien.net>
References: <4BA9D74F.9040507@gmail.com> <4BA7797F.8060605@gmail.com> <20100324155917.GA4382@xanatos> <59ca64281003241107x40c5d83co29d1ee03d8d3a0d1@mail.gmail.com> <20100326184021.GA4350@xanatos>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:38517
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664Ab0CZT2G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2010 15:28:06 -0400
Content-Disposition: inline
In-Reply-To: <20100326184021.GA4350@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Jonas Schwertfeger <jschwertfeger@gmail.com>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 26, 2010 at 11:40:21AM -0700, Sarah Sharp wrote:
> I think the amount of information is fine, but I'm not sure why the
> device would respond with a stall to this particular command, so I'm
> CC'ing the USB storage list and SCSI list.  Does anyone know what the
> third command is?  The USB storage driver reports it as an "unknown
> command".  I can see from scsi.h that 0x85 is the code for ATA_16, but
> I'm not sure what that command actually does.

I've got nothing.  BUT, usb-storage translates the command codes to names
via a table maintained by the SCSI people.  If it's not in the table, then
it's very likely coming from a userspace program.

> Mar 24 18:53:36 js-workstation kernel: [  253.414217] usb-storage: queuec=
ommand called
> Mar 24 18:53:36 js-workstation kernel: [  253.414222] usb-storage: *** th=
read awakened.
>=20
> Mar 24 18:53:36 js-workstation kernel: [  253.414223] usb-storage: Comman=
d (unknown command) (16 bytes)
> Mar 24 18:53:36 js-workstation kernel: [  253.414224] usb-storage:  85 08=
 2e 00 00 00 00 00 00 00 00 00 00 40 ec 00
> Mar 24 18:53:36 js-workstation kernel: [  253.414229] usb-storage: Bulk C=
ommand S 0x43425355 T 0x2f L 512 F 128 Trg 0 LUN 0 CL 16
> Mar 24 18:53:36 js-workstation kernel: [  253.414230] usb-storage: usb_st=
or_bulk_transfer_buf: xfer 31 bytes
> Mar 24 18:53:36 js-workstation kernel: [  253.414378] usb-storage: Status=
 code 0; transferred 31/31
> Mar 24 18:53:36 js-workstation kernel: [  253.414379] usb-storage: -- tra=
nsfer complete
> Mar 24 18:53:36 js-workstation kernel: [  253.414380] usb-storage: Bulk c=
ommand transfer result=3D0
> Mar 24 18:53:36 js-workstation kernel: [  253.414381] usb-storage: usb_st=
or_bulk_transfer_sglist: xfer 512 bytes, 1 entries
> Mar 24 18:53:36 js-workstation kernel: [  253.414458] xhci_hcd 0000:03:00=
.0: WARN: Stalled endpoint
> Mar 24 18:53:36 js-workstation kernel: [  253.414529] usb-storage: Status=
 code -32; transferred 0/512
> Mar 24 18:53:36 js-workstation kernel: [  253.414530] usb-storage: cleari=
ng endpoint halt for pipe 0xc0008280
> Mar 24 18:53:36 js-workstation kernel: [  253.414532] usb-storage: usb_st=
or_control_msg: rq=3D01 rqtype=3D02 value=3D0000 index=3D81 len=3D0
> Mar 24 18:53:36 js-workstation kernel: [  253.414894] usb-storage: usb_st=
or_clear_halt: result =3D 0
> Mar 24 18:53:36 js-workstation kernel: [  253.414895] usb-storage: Bulk d=
ata transfer result 0x2
> Mar 24 18:53:36 js-workstation kernel: [  253.414896] usb-storage: Attemp=
ting to get CSW...
> Mar 24 18:53:36 js-workstation kernel: [  253.414897] usb-storage: usb_st=
or_bulk_transfer_buf: xfer 13 bytes
> Mar 24 18:53:36 js-workstation kernel: [  253.414902] xhci_hcd 0000:03:00=
.0: WARN halted endpoint, queueing URB anyway.
> Mar 24 18:53:36 js-workstation kernel: [  253.415168] usb-storage: Status=
 code 0; transferred 13/13
> Mar 24 18:53:36 js-workstation kernel: [  253.415169] usb-storage: -- tra=
nsfer complete
> Mar 24 18:53:36 js-workstation kernel: [  253.415170] usb-storage: Bulk s=
tatus result =3D 0
> Mar 24 18:53:36 js-workstation kernel: [  253.415171] usb-storage: Bulk S=
tatus S 0x53425355 T 0x2f R 512 Stat 0x2
> Mar 24 18:53:36 js-workstation kernel: [  253.415172] usb-storage: -- tra=
nsport indicates error, resetting
> Mar 24 18:53:36 js-workstation kernel: [  253.415174] usb-storage: usb_st=
or_pre_reset
> Mar 24 18:53:36 js-workstation kernel: [  253.415204] usb-storage: usb_st=
or_post_reset
>=20
> I'm trying to figure out if this device would benefit from any USB
> storage quirks being set.

Not that I'm aware of.

I find it interesting that an endpoint stalled, we cleared the endpoint,
but then it is still listed as halted.  That seems odd to me....


Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Pitr!  That's brilliant!  Funded by Microsoft refunds.  What sweet irony!
					-- A.J.
User Friendly, 2/15/1999

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFLrQq9HL9iwnUZqnkRAk/EAJ4yqs/TUI1sHV6VMHZhHWmQBqhCdgCfU2A9
0R7ud978myOuMjWMDxjYkLY=
=anKb
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
