From: NeilBrown <neilb@suse.de>
Subject: Re: mpt2sas + raid10 goes boom
Date: Tue, 9 Apr 2013 14:18:39 +1000
Message-ID: <20130409141839.70f0fe08@notabene.brown>
References: <20130408071834.GA15457@onthe.net.au>
	<20130408075351.GA16422@onthe.net.au>
	<20130408093242.34100af7@jlaw-desktop.mno.stratus.com>
	<20130409022229.GA2872@onthe.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FS7Or5rBRptHJW6faUrU5Y8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130409022229.GA2872@onthe.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Dunlop <chris@onthe.net.au>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Sig_/FS7Or5rBRptHJW6faUrU5Y8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Apr 2013 12:22:29 +1000 Chris Dunlop <chris@onthe.net.au> wrote:


> > Neil -- should c8dc9c6 go to stable?
>=20
> I think it definitely should. Without it you can't create a
> raid10 and it looks like you have a controller issue!

It is too late for 3.7, but it probably makes sense for 3.8.
I suggest you ask get confirmation from the author,
Joe Lawrence <joe.lawrence@stratus.com>, (oh wait, you already did!)
and when Joe confirms, email stable@vger.kernel.org and ask them to add
it.

NeilBrown


--Sig_/FS7Or5rBRptHJW6faUrU5Y8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUWOWnznsnt1WYoG5AQKB8BAAiTSgL9mcwmQGSx1QqCv5PzIFmGNFNuFH
/++SdO+jBRzdx4/iyXPe7N4ddF+J/VIlfto37gSpmnh4DSx9JDJxx00V/AbHw1id
W54QLhP642XCmCgVbIwuSUBWG1H/bgzDbc9TG2kbfT+VFz/Ul2swqfU42cWvRW72
4kqcbDOvFNFUhOoJmz2ke+uyp0Ku8CxOmIEdCwyB4hjCeeT9lvLHxJy2RIBCbPZ8
WdzAbt7Nia7omSSi+anmTaeQH4bIRdNPlF3jgq+itW1PT77Mbhy6vau80s8BJHfT
sDGbL8LxKGiF7iMUxjiBY/TRfCl3BTUwDQr57MREv2f2ATrh+HhM70Djj0Z2FC8/
ynbDCdva/4eoRJ0sP2AFojILjokAIGcbT8RDLhq3BCNiNJPiSroM6TvfGEgsGiQI
8MjbMYMAJIAOrIQsqQsv2Zstyv6xuElZAmR+7SSzU0u4VlyUf0BqoAQE9usepney
+wfplumfxqaagx/xYYUgj4MFkJlxxhUgMIwHUhFvSXlHfD1nORhj5GlgSXbd0PrT
jd18LcGR5IQGxt6AGm9s4AsiurfIF9fdptl82KHZyywUMRQkDLwL9R/mZvsfJl56
Ylla+YygqQggunmHwsXxQWfNYyCYLnInqGJ/tgCHPGQ/9MNgUjyMCo/eA3umrroK
e5HNV1ju/EM=
=HWas
-----END PGP SIGNATURE-----

--Sig_/FS7Or5rBRptHJW6faUrU5Y8--
