From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: Time to conclude the Sony USB mass storage thread
Date: Sat, 15 Nov 2003 12:20:52 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031115122052.A9275@one-eyed-alien.net>
References: <20031114125648.A5811@beaverton.ibm.com> <20031114181312.A1790@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:3602 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S262009AbTKOUU6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Nov 2003 15:20:58 -0500
Content-Disposition: inline
In-Reply-To: <20031114181312.A1790@beaverton.ibm.com>; from patmans@us.ibm.com on Fri, Nov 14, 2003 at 06:13:12PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, usb-storage@one-eyed-alien.net, SCSI Mailing List <linux-scsi@vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I presume your testing included mount, read, write, and umount?

I'm okay with the patch.  It could use some more comments, but that's not
really necessary.

Matt

On Fri, Nov 14, 2003 at 06:13:12PM -0800, Patrick Mansfield wrote:
> I went ahead and tested the patch with a Sony / Sony DSC on my laptop with
> no problems.
>=20
> James, Matthew, etc. - are you OK with the patch?
>=20
> Here's usb storage debug output on attach of the device, note the lack of
> any MODE SENSE:
>=20
> Nov 14 18:01:47 laptop patman: NOTE attaching NOTE
> Nov 14 18:01:56 laptop kernel: usb-storage: USB Mass Storage device detec=
ted
> Nov 14 18:01:56 laptop kernel: usb-storage: act_altsetting is 0, id_index=
 is 25
> Nov 14 18:01:56 laptop kernel: usb-storage: -- associate_dev
> Nov 14 18:01:56 laptop kernel: usb-storage: Vendor: Sony
> Nov 14 18:01:56 laptop kernel: usb-storage: Product: DSC-S30/S70/S75/505V=
/F505/F707/F717/P8
> Nov 14 18:01:56 laptop kernel: usb-storage: Transport: Control/Bulk
> Nov 14 18:01:56 laptop kernel: usb-storage: Protocol: Transparent SCSI
> Nov 14 18:01:56 laptop kernel: usb-storage: Endpoints: In: 0xca8bb280 Out=
: 0xca8bb294 Int: 0xca8bb2a8 (Period 255)
> Nov 14 18:01:56 laptop kernel: usb-storage: *** thread sleeping.
> Nov 14 18:01:56 laptop kernel: usb-storage: queuecommand called
> Nov 14 18:01:56 laptop kernel: usb-storage: *** thread awakened.
> Nov 14 18:01:56 laptop kernel: usb-storage: Command INQUIRY (6 bytes)
> Nov 14 18:01:56 laptop kernel: usb-storage:  12 00 00 00 24 00
> Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=3D=
00 rqtype=3D21 value=3D0000 index=3D00 len=3D6
> Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 6/6
> Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:56 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfe=
r() returned 0
> Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: x=
fer 36 bytes
> Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 36=
/36
> Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:56 laptop kernel: usb-storage: CB data stage result is 0x0
> Nov 14 18:01:56 laptop kernel: usb-storage: -- CB transport device requir=
ing auto-sense
> Nov 14 18:01:56 laptop kernel: usb-storage: Issuing auto-REQUEST_SENSE
> Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=3D=
00 rqtype=3D21 value=3D0000 index=3D00 len=3D6
> Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 6/6
> Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:56 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfe=
r() returned 0
> Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: x=
fer 18 bytes
> Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 18=
/18
> Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:56 laptop kernel: usb-storage: CB data stage result is 0x0
> Nov 14 18:01:56 laptop kernel: usb-storage: -- Result from auto-sense is 0
> Nov 14 18:01:56 laptop kernel: usb-storage: -- code: 0x70, key: 0x0, ASC:=
 0x0, ASCQ: 0x0
> Nov 14 18:01:56 laptop kernel: usb-storage: No Sense: No additional sense=
 information
> Nov 14 18:01:56 laptop kernel: usb-storage: Fixing INQUIRY data to show S=
CSI rev 2 - was 0
> Nov 14 18:01:56 laptop kernel: usb-storage: scsi cmd done, result=3D0x0
> Nov 14 18:01:56 laptop kernel: usb-storage: *** thread sleeping.
> Nov 14 18:01:56 laptop kernel: usb-storage: queuecommand called
> Nov 14 18:01:56 laptop kernel: usb-storage: *** thread awakened.
> Nov 14 18:01:56 laptop kernel: usb-storage: Command TEST_UNIT_READY (6 by=
tes)
> Nov 14 18:01:56 laptop kernel: usb-storage:  00 00 00 00 00 00
> Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=3D=
00 rqtype=3D21 value=3D0000 index=3D00 len=3D6
> Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 6/6
> Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:56 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfe=
r() returned 0
> Nov 14 18:01:56 laptop kernel: usb-storage: -- CB transport device requir=
ing auto-sense
> Nov 14 18:01:56 laptop kernel: usb-storage: Issuing auto-REQUEST_SENSE
> Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=3D=
00 rqtype=3D21 value=3D0000 index=3D00 len=3D6
> Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 6/6
> Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:56 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfe=
r() returned 0
> Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: x=
fer 18 bytes
> Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 18=
/18
> Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:56 laptop kernel: usb-storage: CB data stage result is 0x0
> Nov 14 18:01:56 laptop kernel: usb-storage: -- Result from auto-sense is 0
> Nov 14 18:01:56 laptop kernel: usb-storage: -- code: 0x70, key: 0x0, ASC:=
 0x0, ASCQ: 0x0
> Nov 14 18:01:56 laptop kernel: usb-storage: No Sense: No additional sense=
 information
> Nov 14 18:01:56 laptop kernel: usb-storage: scsi cmd done, result=3D0x0
> Nov 14 18:01:56 laptop kernel: usb-storage: *** thread sleeping.
> Nov 14 18:01:56 laptop kernel: usb-storage: queuecommand called
> Nov 14 18:01:56 laptop kernel: usb-storage: *** thread awakened.
> Nov 14 18:01:56 laptop kernel: usb-storage: Command READ_CAPACITY (10 byt=
es)
> Nov 14 18:01:56 laptop kernel: usb-storage:  25 00 00 00 00 00 00 00 00 00
> Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=3D=
00 rqtype=3D21 value=3D0000 index=3D00 len=3D10
> Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 10=
/10
> Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:56 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfe=
r() returned 0
> Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: x=
fer 8 bytes
> Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 8/8
> Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:56 laptop kernel: usb-storage: CB data stage result is 0x0
> Nov 14 18:01:56 laptop kernel: usb-storage: -- CB transport device requir=
ing auto-sense
> Nov 14 18:01:56 laptop kernel: usb-storage: Issuing auto-REQUEST_SENSE
> Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=3D=
00 rqtype=3D21 value=3D0000 index=3D00 len=3D6
> Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 6/6
> Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:56 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfe=
r() returned 0
> Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: x=
fer 18 bytes
> Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 18=
/18
> Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:56 laptop kernel: usb-storage: CB data stage result is 0x0
> Nov 14 18:01:56 laptop kernel: usb-storage: -- Result from auto-sense is 0
> Nov 14 18:01:56 laptop kernel: usb-storage: -- code: 0x70, key: 0x0, ASC:=
 0x0, ASCQ: 0x0
> Nov 14 18:01:56 laptop kernel: usb-storage: No Sense: No additional sense=
 information
> Nov 14 18:01:56 laptop kernel: usb-storage: scsi cmd done, result=3D0x0
> Nov 14 18:01:56 laptop kernel: usb-storage: *** thread sleeping.
> Nov 14 18:01:56 laptop kernel: usb-storage: queuecommand called
> Nov 14 18:01:56 laptop kernel: usb-storage: *** thread awakened.
> Nov 14 18:01:56 laptop kernel: usb-storage: Command TEST_UNIT_READY (6 by=
tes)
> Nov 14 18:01:56 laptop kernel: usb-storage:  00 00 00 00 00 00
> Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=3D=
00 rqtype=3D21 value=3D0000 index=3D00 len=3D6
> Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 6/6
> Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:56 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfe=
r() returned 0
> Nov 14 18:01:56 laptop kernel: usb-storage: -- CB transport device requir=
ing auto-sense
> Nov 14 18:01:56 laptop kernel: usb-storage: Issuing auto-REQUEST_SENSE
> Nov 14 18:01:56 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=3D=
00 rqtype=3D21 value=3D0000 index=3D00 len=3D6
> Nov 14 18:01:56 laptop kernel: usb-storage: Status code 0; transferred 6/6
> Nov 14 18:01:56 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:57 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfe=
r() returned 0
> Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: x=
fer 18 bytes
> Nov 14 18:01:57 laptop kernel: usb-storage: Status code 0; transferred 18=
/18
> Nov 14 18:01:57 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:57 laptop kernel: usb-storage: CB data stage result is 0x0
> Nov 14 18:01:57 laptop kernel: usb-storage: -- Result from auto-sense is 0
> Nov 14 18:01:57 laptop kernel: usb-storage: -- code: 0x70, key: 0x0, ASC:=
 0x0, ASCQ: 0x0
> Nov 14 18:01:57 laptop kernel: usb-storage: No Sense: No additional sense=
 information
> Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=3D0x0
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
> Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
> Nov 14 18:01:57 laptop kernel: usb-storage: Command ALLOW_MEDIUM_REMOVAL =
(6 bytes)
> Nov 14 18:01:57 laptop kernel: usb-storage:  1e 00 00 00 01 00
> Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=3D=
00 rqtype=3D21 value=3D0000 index=3D00 len=3D6
> Nov 14 18:01:57 laptop kernel: usb-storage: Status code -32; transferred =
6/6
> Nov 14 18:01:57 laptop kernel: usb-storage: -- stall on control pipe
> Nov 14 18:01:57 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfe=
r() returned 2
> Nov 14 18:01:57 laptop kernel: usb-storage: -- CB transport device requir=
ing auto-sense
> Nov 14 18:01:57 laptop kernel: usb-storage: -- transport indicates comman=
d failure
> Nov 14 18:01:57 laptop kernel: usb-storage: Issuing auto-REQUEST_SENSE
> Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=3D=
00 rqtype=3D21 value=3D0000 index=3D00 len=3D6
> Nov 14 18:01:57 laptop kernel: usb-storage: Status code 0; transferred 6/6
> Nov 14 18:01:57 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:57 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfe=
r() returned 0
> Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: x=
fer 18 bytes
> Nov 14 18:01:57 laptop kernel: usb-storage: Status code 0; transferred 18=
/18
> Nov 14 18:01:57 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:57 laptop kernel: usb-storage: CB data stage result is 0x0
> Nov 14 18:01:57 laptop kernel: usb-storage: -- Result from auto-sense is 0
> Nov 14 18:01:57 laptop kernel: usb-storage: -- code: 0x70, key: 0x5, ASC:=
 0x20, ASCQ: 0x0
> Nov 14 18:01:57 laptop kernel: usb-storage: Illegal Request: Invalid comm=
and operation code
> Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=3D0x2
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
> Nov 14 18:01:57 laptop kernel: usb-storage: Command READ_10 (10 bytes)
> Nov 14 18:01:57 laptop kernel: usb-storage:  28 00 00 00 00 00 00 00 08 00
> Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=3D=
00 rqtype=3D21 value=3D0000 index=3D00 len=3D10
> Nov 14 18:01:57 laptop kernel: usb-storage: Status code 0; transferred 10=
/10
> Nov 14 18:01:57 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:57 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfe=
r() returned 0
> Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_bulk_transfer_sglist=
: xfer 4096 bytes, 1 entries
> Nov 14 18:01:57 laptop kernel: usb-storage: Status code 0; transferred 40=
96/4096
> Nov 14 18:01:57 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:57 laptop kernel: usb-storage: CB data stage result is 0x0
> Nov 14 18:01:57 laptop kernel: usb-storage: -- CB transport device requir=
ing auto-sense
> Nov 14 18:01:57 laptop kernel: usb-storage: Issuing auto-REQUEST_SENSE
> Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_ctrl_transfer: rq=3D=
00 rqtype=3D21 value=3D0000 index=3D00 len=3D6
> Nov 14 18:01:57 laptop kernel: usb-storage: Status code 0; transferred 6/6
> Nov 14 18:01:57 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:57 laptop kernel: usb-storage: Call to usb_stor_ctrl_transfe=
r() returned 0
> Nov 14 18:01:57 laptop kernel: usb-storage: usb_stor_bulk_transfer_buf: x=
fer 18 bytes
> Nov 14 18:01:57 laptop kernel: usb-storage: Status code 0; transferred 18=
/18
> Nov 14 18:01:57 laptop kernel: usb-storage: -- transfer complete
> Nov 14 18:01:57 laptop kernel: usb-storage: CB data stage result is 0x0
> Nov 14 18:01:57 laptop kernel: usb-storage: -- Result from auto-sense is 0
> Nov 14 18:01:57 laptop kernel: usb-storage: -- code: 0x70, key: 0x0, ASC:=
 0x0, ASCQ: 0x0
> Nov 14 18:01:57 laptop kernel: usb-storage: No Sense: No additional sense=
 information
> Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=3D0x0
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
> Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
> Nov 14 18:01:57 laptop kernel: usb-storage: Bad target number (1:0)
> Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=3D0x400=
00
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
> Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
> Nov 14 18:01:57 laptop kernel: usb-storage: Bad target number (2:0)
> Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=3D0x400=
00
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
> Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
> Nov 14 18:01:57 laptop kernel: usb-storage: Bad target number (3:0)
> Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=3D0x400=
00
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
> Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
> Nov 14 18:01:57 laptop kernel: usb-storage: Bad target number (4:0)
> Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=3D0x400=
00
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
> Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
> Nov 14 18:01:57 laptop kernel: usb-storage: Bad target number (5:0)
> Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=3D0x400=
00
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
> Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
> Nov 14 18:01:57 laptop kernel: usb-storage: Bad target number (6:0)
> Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=3D0x400=
00
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
> Nov 14 18:01:57 laptop kernel: usb-storage: queuecommand called
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread awakened.
> Nov 14 18:01:57 laptop kernel: usb-storage: Bad target number (7:0)
> Nov 14 18:01:57 laptop kernel: usb-storage: scsi cmd done, result=3D0x400=
00
> Nov 14 18:01:57 laptop kernel: usb-storage: *** thread sleeping.
> Nov 14 18:01:57 laptop kernel: WARNING: USB Mass Storage data integrity n=
ot assured
> Nov 14 18:01:57 laptop kernel: USB Mass Storage device found at 3
> Nov 14 18:02:11 laptop patman: NOTE attach COMPLETED NOTE

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Somebody call an exorcist!
					-- Dust Puppy
User Friendly, 5/16/1998

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/toqkIjReC7bSPZARAqaYAKCHVCFJ+lOGKyiDroAVsWK517khHQCdFdNz
RMGBpM50Ch71Ru51aT2VWkI=
=naR2
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
