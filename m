From: Mohammed Sameer <uniball@gmx.net>
Subject: Re: BUG: CD driver sends command during host removal
Date: Mon, 27 Sep 2004 21:51:53 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040927185153.GN1695@uniball>
References: <20040926082926.GA1944@uniball> <Pine.LNX.4.44L0.0409271358300.1928-100000@ida.rowland.org>
Reply-To: Mohammed Sameer <uniball@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4oQnj4jcM03NhqPN"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [62.135.86.39] ([62.135.86.39]:46787 "EHLO uniball.foolab.org")
	by vger.kernel.org with ESMTP id S267186AbUI0Sx3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2004 14:53:29 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0409271358300.1928-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, USB users list <linux-usb-users@lists.sourceforge.net>


--4oQnj4jcM03NhqPN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 27, 2004 at 02:18:51PM -0400, Alan Stern wrote:
> I received the following error report, showing that something in the CD=
=20
> driver attempts to send a command to a USB CD-RW drive when the host is=
=20
> removed, leading to an oops.  This was on a 2.6.9-rc2 system (Mohammed=20
> please correct me if that's wrong).

thanks Alan for posting this to this mailing list.
Yes i'm using a vanilla 2.6.9-rc2 on Debian testing.

I'm now subscribed to this mailing list,
And I can provide any required information.

Best refards,

--=20
----------------
-- Katoob Main Developer
Linux registered user #224950, ICQ #58475622
--
Don't send me any attachment in Micro$oft (.DOC, .PPT) format please
Read http://www.fsf.org/philosophy/no-word-attachments.html
Preferable attachments: .PDF, .HTML, .TXT
Thanx for adding this text to Your signature
--
-----BEGIN GEEK CODE BLOCK-----
Version: 3.1
GCM/IT d-(++)@ s+(++):->+++ a-- C+++$>++++ UL+++$>++++ P+++$>+++++
L+++(++++)$>+++++ E>+++ W++?>$ N+>+++ o? K-? !w++ !O !M !V !PS@ !PE@ Y+ PGP=
=3D+++
t? 5? !X R? tv-- b+@ DI D+ G-- e++>+++ h-->++ !r y?
------END GEEK CODE BLOCK------

--4oQnj4jcM03NhqPN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBWGFJy2aOKaP9DfcRAoHRAJ9tuwwUJR720odbMs71i1SGzQ4ukwCeOy84
YZznGXs+/GUlbyw/2oKbOvc=
=0DXF
-----END PGP SIGNATURE-----

--4oQnj4jcM03NhqPN--
