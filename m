From: Thomas Schwinge <thomas@codesourcery.com>
Subject: Re: Linux kernel crash (3.2.0-2-amd64) when trying to play audio CD
Date: Sat, 22 Sep 2012 13:53:20 +0200
Message-ID: <87ehlu5l5b.fsf@schwinge.name>
References: <87obojef7t.fsf@schwinge.name> <20120616181008.GB20623@liondog.tnic> <87ehpddw9k.fsf@schwinge.name> <20120618142900.GA9710@aftab.osrc.amd.com> <87sjdsd64r.fsf@schwinge.name> <20120618155141.GF8378@aftab.osrc.amd.com> <877gs69oue.fsf@schwinge.name> <20120913125825.GB19691@aftab.osrc.amd.com> <20120917172345.GH13879@aftab.osrc.amd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg=pgp-sha1;
	protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:32929 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2IVLxd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Sep 2012 07:53:33 -0400
In-Reply-To: <20120917172345.GH13879@aftab.osrc.amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Borislav Petkov <bp@amd64.org>
Cc: Borislav Petkov <bp@alien8.de>, debian-kernel@lists.debian.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Borislav!

On Mon, 17 Sep 2012 19:23:45 +0200, Borislav Petkov <bp@amd64.org> wrote:
> On Thu, Sep 13, 2012 at 02:58:25PM +0200, Borislav Petkov wrote:
> > Here's the script, let me know how it goes:
>=20
> Here's a more correct version. I'm not saying yours won't work based
> on the rdmsr and setpci output on your box, but here's a version which
> should pay attention to one other workaround and work on all K8s.

Thanks for that.  I invoke it from /etc/rc.local, and then get:

    $ sudo setpci -s 18.0 0x68.l
    0f20cc0f
    $ sudo rdmsr 0xc001001f
    100000008

Previously that was:

    $ sudo setpci -s 18.0 0x68.l
    0f00cc0f
    $ sudo rdmsr 0xc001001f
    8

However, putting in that one audio CD still crashes the machine:
<http://schwinge.homeip.net/~thomas/tmp/linux-crash-audio-cd-2.jpeg>.
Original (identical, from a quick glance) MCE is at
<http://schwinge.homeip.net/~thomas/tmp/linux-crash-audio-cd.jpeg>.


Gr=C3=BC=C3=9Fe,
 Thomas

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJQXaawAAoJENuKOtuXzphJVVcIAKmb101eB6XCgHkoX7mO9uNf
Dn28TLSYpiRoNq8k2+tMz3h9Wy0gaWSGGqvJU+3tC17pWP/lXMhQAPw43I7z7TF2
LaQgQ3HF719tn67V0Mfsdd0LcXVUnHmT9RdwlPKhzaZZZ10OgKCsOF9S8QXdMV9J
S1NgKJ413Wdy/UAeB7NjMDCZBt+fOh+M4r2EDoIkOcIZHlrRdgPCJ6jObZNisJjN
tMMR/Qy4prMTwPDH1/PxYkKr3jWvgAAcnxI40Jw9AN4+gDqcWfxFObu72ajYM2Ba
9xanTwM+eFXkppwXYqU1YFZ9k9hmQU/gGk4jDVupVd7w8pEmv136olIVCfpDWUA=
=dHko
-----END PGP SIGNATURE-----
--=-=-=--
