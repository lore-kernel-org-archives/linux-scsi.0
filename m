From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: Re: BUG: KASAN: slab-out-of-bounds in
 ses_enclosure_data_process+0x900/0xe50
Date: Thu, 3 Dec 2015 21:36:56 +0100
Message-ID: <20151203203656.GA9278@glen>
References: <20151201202053.GA4753@glen>
 <1449097101.2203.67.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35932 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbbLCUhE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2015 15:37:04 -0500
Content-Disposition: inline
In-Reply-To: <1449097101.2203.67.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


--zx4FCpZtqtKETZ7O
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 02, 2015 at 02:58:21PM -0800, James Bottomley wrote:
> On Tue, 2015-12-01 at 21:20 +0100, Andrea Gelmini wrote:
> OK, this looks like some type of problem with a USB enclosure.  It's
> probably misreporting something in the mode pages.  can you run sg_ses
> on whatever /dev/sg<n> the enclosure turns up as?


root@glen:/tmp/report# cat sg_ses_usb_hd.txt=20
  WD        My Passport 0820  1007
    disk device (not an enclosure)
Supported diagnostic pages:
  Supported Diagnostic Pages [sdp] [0x0]
  Short Enclosure Status (SES) [ses] [0x8]
  <unknown> [0x80]
  <unknown> [0x83]
  <unknown> [0x84]
  <unknown> [0x85]


By the way, same issue with kernel 4.3 (6a13feb9c82803e2b815eca72fa7a9f5561=
d7861).
Attached the dmesg output.

Thanks a lot,
Andrea

--ew6BAiZeqk4r7MaW
Content-Type: application/gzip
Content-Disposition: attachment; filename="dmesg.txt.gz"
Content-Transfer-Encoding: base64

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
HPi/MW7+x4+mqPju/35iURV+RgAA

--ew6BAiZeqk4r7MaW--

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQJ8BAEBCgBmBQJWYKfoXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25zLm9w
ZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXRFQTQyRTkzNjBCNzVERDZFODMyNTQ3RjdB
NDMwOTA3NUYwNTk2MEY2AAoJEKQwkHXwWWD2s+MP/0EdYMJZvaAVq2PNlBEUTmNl
mW4tY+N6sShnhUxwIQrurLxlpfTqadpuMeIJG3V56PX61A0MKkELLnC3ibBqj5Zw
+6XpAlR5GWyQSh10LCVMYUItFEXld8DHn2Xxvlq30kYV4iyLZM039QeiXMSH0Wp3
EnSWhJZEQPs9ot4uEEUySiooKkDkP32JoXsPLxFcCmCDMxEZ2+Mt2WmAk2VMrGbF
1KUHXa+nUSV36NZNmfAHlcijcaqKOnyY8uttEu+rLMMsq1EUJggAEkitvwPSR452
gFcrp4mdyWttaM7WFuamKMnP8JTco8l9+gmSBVvkNVvb/kBJzIyTBYGJezhhdmr8
ROj3OAAT+zaKv8G5Qs3VFrzK4zvqSC8p5QF9g7ehTKHX8nBWwwM4Ul3gVINRH1FL
5CHCZj9ouqu9gb7/vs/r2ETTyT6XdWMPXCNmcdMrHly4iQK2zDkvDw2bEKGpv7Q4
iwafufLfGCZb2+j6cYXdhGAZQwJZsD/sFgM9UaBX19o2uCqFGujHset8LqA/ueDy
ZrSjBGOAximw4KzaFve/6JMKUpBUT5M1iNfNuFWn28u8H+BZzB6y6rjlFIWbxSLl
PIVw0MAs46FNzAGzyS0uODI80frdEQBUWN1i4Escej8X84Lsj8V+teNiHDJ7Jc2i
E4qW5zLWF5BNJ7oYGhyx
=z7ec
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
