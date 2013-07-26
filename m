From: Ritesh Raj Sarraf <rrs@debian.org>
Subject: Re: targetcli -fb now also Apache 2.0 licensed
Date: Fri, 26 Jul 2013 12:54:21 +0530
Message-ID: <51F22425.6000801@debian.org>
References: <51EF73EF.1040305@redhat.com>  <1374696565.7397.1292.camel@haakon3.risingtidesystems.com>  <1374697264.7382.39.camel@dabdike>  <1374699289.7397.1309.camel@haakon3.risingtidesystems.com>  <51F06C17.50306@redhat.com> <1374715140.7397.1390.camel@haakon3.risingtidesystems.com> <51F1ED9D.50300@redhat.com>
Reply-To: rrs@debian.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2SAWTHVNSUUCNELQKKVBS"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <51F1ED9D.50300@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, targetcli-fb-devel@lists.fedorahosted.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2SAWTHVNSUUCNELQKKVBS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Friday 26 July 2013 09:01 AM, Andy Grover wrote:
>
> It's one thing to claim a prerogative of "upstream", but for this to
> make sense, there needs to be an actual community around the upstream.
> And if there's going to be submissions for review, then there needs to
> be someone in charge of the community with a high degree of skill in
> the code base. Nick you have a great deal of technical expertise
> around the C code in drivers/target, but Jerome was the one who wrote
> rtslib, targetcli, and configshell. I believe you can assess the
> technical aspects of how the user library interacts with the kernel
> code, but the maintainer should also be extremely conversant in the
> language the library is written in. In this case, Python. So it's not
> clear to me if submitting the code would actually result in meaningful
> code improvements.
>
> Also, there has been no effort to sustain a community around this
> code. There is no bug tracking, no separate mailing list, no regular
> releases. Debian is running ancient, broken code because nothing's
> been tagged in over two years.
>
> I would love to have you maintain and improve this code, but if you
> aren't then you can't just say "I'm the upstream bow to me!". We're
> shipping this code in Fedora and it needs active maintenance. Now that
> we're all on an even licensing footing, code can flow both ways, and
> even into your commercial version.=20

Yes. Apart from reaching out the developers directly, I am not aware of
other communication channels. There is a git and wiki though.

Nick, if you guys have the same license now, nothing should stop you to
pull the changes from the targetcli-fb repo. You can start afresh now
and comply with what the community guidelines are. Licensing is just one
part of it.

And regarding this whole licensing dispute in the open, the kernel
maintainers should have resolved this long ago, when it was decided to
have LIO as the in-kernel target for Linux.
You might say that the target component complied by the kernel's
licensing requirements. But for a subsystem inclusion, you don't look
just at the code, but also the maintainer. Their support tools. And
their long term plans. These rules have been applied, in the past, for
other features in the kernel.

--=20
Ritesh Raj Sarraf | http://people.debian.org/~rrs
Debian - The Universal Operating System



------enig2SAWTHVNSUUCNELQKKVBS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iQIcBAEBCgAGBQJR8iQlAAoJEKY6WKPy4XVpkCgP/1AXMDLzzBYV1aueldK0yhwT
DLAX4VvEByaPtq4eigA9S5AAS0CP+WO2v7umjCxHZ5LQ9WKhpgu2SBf1umEcSbet
1cZ260FtlXemxMR4lfmrBtFi+835nq6YEx0M7gy1HciYSX9CfodPvhBXW4EFpEFB
UUI9VgmAFOy+31IXXuVwnb55vKjQ8U7zkuVElWTjA38i3zYfAdCBeXW/w3LAUx02
FdlQ/FNAeInsbLN9b5Mfm7UCwhn3Doz6P3MIJG5yC+iRHz3qQ9JTKHvGXSDkVJDP
CW5xZawyu86vrnb85KdceMHRUuWXD35RW6238x4dP2veo3iI/9hxtzoTNxhuBLEE
KygPwuRudPaQUEJhfGRxeaC7fJwL+R7asuom3/SPdIPcMqURBhHp/2s1pCPQu05v
5DnYVybFqiTGZQkOXmATV08AEL8xDHhKoE6BkNOO6PGzsQBfM35Qu0RVIchdG8KF
8h5QHiUlm7kwPgTOFinBMYMQ3I8Nn2HTuW7T/TSULIAIIs/lmkDkawet/BnaQVTw
7chaj8/tJ1b4HT2F7C5fqG8nWaFrsO2eLVYbD5Uk863trpwaSFJcM48+I3VL9zCR
lBY8+ukF6EgKaBF/C52xzKULfA3FJ5lkcXDNRD/wvqNWhurnkI48+qbziM+Khj2Z
0lWUA2WYtXbdS9pX2mwX
=Jn5D
-----END PGP SIGNATURE-----

------enig2SAWTHVNSUUCNELQKKVBS--
