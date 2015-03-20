From: Christian Hesse <list@eworm.de>
Subject: Re: iSCSI regression with linux 3.9 and 4.0
Date: Fri, 20 Mar 2015 18:59:01 +0100
Message-ID: <20150320185901.0283191c@leda.localdomain>
References: <20150320135742.63df219b@leda.localdomain>
	<1426859486.19806.30.camel@localhost.localdomain>
	<20150320153104.086f3b46@leda.localdomain>
	<1426863883.19806.65.camel@localhost.localdomain>
	<20150320162441.684366b6@leda.localdomain>
	<1426866365.19806.81.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/A5_/StMr3aj_iobsbJSPCVi"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.mylinuxtime.de ([148.251.109.235]:53249 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbbCTR7S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2015 13:59:18 -0400
In-Reply-To: <1426866365.19806.81.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ewan Milne <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

--Sig_/A5_/StMr3aj_iobsbJSPCVi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Ewan Milne <emilne@redhat.com> on Fri, 2015/03/20 11:46:
> On Fri, 2015-03-20 at 16:24 +0100, Christian Hesse wrote:
> > I found 'max_sectors_kb' which is inside in directory called 'queue'. Is
> > that the value you asked for?
> >=20
> > for 4.0 git:
> >=20
> > # cat max_sectors_kb
> > 32767
>=20
> If you change max_sectors_kb to a lower value (e.g. 512) can you get the
> device to work?

I will check that on monday. Sitting behind a slow dial up connection right
now...
=20
> There is a max_hw_sectors_kb value but you can't change it.  Is it
> 32768 also for 4.0?

# cat max_hw_sectors_kb
32767

It's 3276*7*, not 32768.

> Your device reports a maximum transfer length of 2^32-1 blocks but
> I suspect that it might not be actually able to do that.  I don't see
> what else would be causing the error.  Maybe there is a transport
> limitation that is getting in the way?

What kind of transport limitation can that be? Network MTU and friends shou=
ld
no be an issue, no?
--=20
main(a){char*c=3D/*    Schoene Gruesse                         */"B?IJj;MEH"
"CX:;",b;for(a/*    Chris           get my mail address:    */=3D0;b=3Dc[a+=
+];)
putchar(b-1/(/*               gcc -o sig sig.c && ./sig    */b/42*2-3)*42);}

--Sig_/A5_/StMr3aj_iobsbJSPCVi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVDF/lAAoJEIlFIdfMgPR2IcQH/RxjWwhz3fvVmjAPmMyAoOeI
1cTXOokdO/naYni/VE5AfQ+Wuis7qrJEWZHI5al2H/7A0s3gtB288lt5vrxhd9y9
U3COTC9fBC8zpobmnZm9eUuAOCcum8u8ni0IqyCktNmVBNkHoiNo0NQgIc439hz5
wX2cAmPsvOYO0hm1yqekJ+J9SiXEqMcLK5ihMA7NAp68qtxPQLIARyQVCVgtqhH1
sH7rSzqJQ7jRyh0I4YDfPKi2uMs0yDIWaODN8F4THFjXiTzy6M8Hd2GxllUhQu+g
4pb7Cl6/40QPr9VXqk+32Q47f1oHh2I0Gl1mfe3ZUE4l/gk+GK3VhOUaoz06sTA=
=XoXC
-----END PGP SIGNATURE-----

--Sig_/A5_/StMr3aj_iobsbJSPCVi--
