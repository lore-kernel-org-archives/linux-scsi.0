From: Paul Menzel <paul.menzel@giantmonkey.de>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>]
 sr_runtime_suspend+0xc/0x20 [sr_mod]
Date: Tue, 19 Jan 2016 17:52:53 +0100
Message-ID: <1453222373.3588.3.camel@giantmonkey.de>
References: <Pine.LNX.4.44L0.1601191127020.1727-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-JKWXd0Fwv2CMiHEBay6j"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38053 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbcASQxI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2016 11:53:08 -0500
Received: by mail-wm0-f44.google.com with SMTP id b14so181164698wmb.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jan 2016 08:53:07 -0800 (PST)
In-Reply-To: <Pine.LNX.4.44L0.1601191127020.1727-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Erich Schubert <erich@debian.org>, Ben Hutchings <ben@decadent.org.uk>, SCSI development list <linux-scsi@vger.kernel.org>, 801925@bugs.debian.org, Alexandre Rossi <alexandre.rossi@gmail.com>


--=-JKWXd0Fwv2CMiHEBay6j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Alan, dear Erich,


Am Dienstag, den 19.01.2016, 11:38 -0500 schrieb Alan Stern:
> On Tue, 19 Jan 2016, Erich Schubert wrote:

> > Attached are photos of the Kernel null pointer BUG that I'm observing.
> >=20
> > These shots are with 4.4.0-rc8.
> > As you can see, I have a similar trace to Paul, but the error occurs
> > one stack frame earlier?
>
> Yours is only slighly similar to Paul's.  He got an error in=20
> sr_runtime_suspend, but your error occurs in sd_resume -- a completely
> different function in a different source file.

if I remember correctly, it happened it different places for me too. In
the backlog you should see, that Ben gave me a patch to try and then it
wasn=E2=80=99t triggered as it failed somewhere else.

> > Maybe Alex issue is the same bug, but triggered slightly different or
> > just the kernel compiled differently.
> > __rpm_callback, scsi_autopm_put_device, __pm_runtime_resume, sd_probe
> > is present in all of these traces.
> >=20
> > Sorry, I do not have a lot of time right now to help testing or debuggi=
ng.
>
> I can't tell what's going wrong without some real debugging.  This
> means somebody has to build and test a patched kernel.  There are no
> problems on my computer, so it will have to be one or more of you
> guys.

Could you please attach the debugging patch. Hopefully Alexandre, Erich,
or I will have some spare time to build an image from it.

Alan, thank you a lot for being so responsive and helpful!


Thanks,

Paul
--=20
GPG-Schl=C3=BCssel: 33623E9B
Fingerabdruck =3D 0EB1 649D 4361 D04F 3C70  6F71 4DD7 BF75 3362 3E9B

Giant Monkey Software Engineering GmbH

Brunnenstr. 7D
10119 Berlin Mitte

Gesch=C3=A4ftsf=C3=BChrer Adrian Fuhrmann, Lion Vollnhals und Paul Menzel

USt-IdNr.: DE281524720
HRB 139495 B Amtsgericht Charlottenburg

--=-JKWXd0Fwv2CMiHEBay6j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWnmnvAAoJEE3Xv3UzYj6bMUUP/RywY6802gBMHuNrfAUI9P8q
+hHOLgyoB+RlppUfqmCdLfBLKtMUqWT9IBgFphjGwxbinNqaftF4KxBmJRqlEgpI
y+cOCK5nyjP4vJpRgSNO1DezaXa/vzirVFK6se62/V9Z6ow6guu9xxZtMS6OeOMA
6bw5R1qosd4cCmJ2h0s0kol4McpsplZQ7XLKhEALNLkCUmlgMXjqITmRaCX+IBgv
EsFaqKu0F5eeLtYZfRUgLB58IllvZLfjcxOKRDLDAMApofWc6L07MMzFknfK0ney
QfNDuiQafNzPJ+2wfwWfXmB492NgnPMz1SXn96RxGSN3+0LsyPRVsGP9R1ldppQX
OQaGItKA59+wrbCbreHjwogQWbs7fyClmzvx1dj6+9KN2nLyMnlKRAXR/XvAaR/U
+Q9wr63wn8UG6xcLgPA/TIqGgHRMoz20nK4g8ChL9G/cLK7SH8X0wwP7g22gyvTC
lMIP7sjunEzfIq1WW+ohqPvilcPEt5Fc5JeV+QgjXBa/LGg4Uhe/xTAiGtkZHeHx
GP2AeTyGDaEN7iD6L531LNB4oj2HruZudL3eIdsjtiV3gNmr9VGYQsCwbitilplh
Hy7oBiiLYXbUhHATnuK5KitLvb1QYGhJQABlh/P+ZK792jkBGI9UZ6hgjFJAjLm+
C02hIzAbTkM37y0uK1zv
=WMms
-----END PGP SIGNATURE-----

--=-JKWXd0Fwv2CMiHEBay6j--

