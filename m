From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: RE: [ATTEND]
Date: Wed, 08 Feb 2012 22:20:03 +0200
Message-ID: <1328732432.2101.3.camel@koala>
References: <CAH+dOxKMwMskM18=GhBmEao4aSvZmccSiZmmnZm42TBMPUFONw@mail.gmail.com>
	<D3F292ADF945FB49B35E96C94C2061B915D0A6CB@nsmail.netscout.com>
	 <CAH+dOx+4mL0uMBAjv+zo+XGJvaZvushYT5=Ev=8K8-zVhLHR2w@mail.gmail.com>
	 <D3F292ADF945FB49B35E96C94C2061B915D0ACF0@nsmail.netscout.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-sMXnraNMJkJW9Z3JHste"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B915D0ACF0@nsmail.netscout.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: Kent Overstreet <koverstreet@google.com>, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, dedekind@infradead.org
List-Id: linux-scsi@vger.kernel.org


--=-sMXnraNMJkJW9Z3JHste
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-02-08 at 13:15 -0500, Loke, Chetan wrote:
> Exactly. So what I'm saying is, if UBI also does ftl then you could be
> duplicating code/efforts. UBI is already upstream. Now whether it
> supports everything we want is another thing.
> (and that's why I CC'd its author). So pieces that aren't there could be
> implemented. But they also talk about erase-counters etc and I don't
> know if I saw something similar in your bucket_struct[or foo_struct].
> May be its somewhere else.

Hi, UBI is not an FTL, but it implements a lot of things a decent FTL
would also need to implement. And implementing FTL on top of UBI would
be much simpler than on top of a raw flash (I assume you are discussing
a flash?). UBI has it's own strong sides and limitations. Here I
described a simple FTL on top of UBI (long time ago):

http://lists.infradead.org/pipermail/linux-mtd/2008-January/020381.html

--=20
Best Regards,
Artem Bityutskiy

--=-sMXnraNMJkJW9Z3JHste
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPMtjzAAoJEJtuLFy+q7feoQEH/jn1cQ4icZdohrF3w0IH9W7H
IWgCN3hGVat5zO7j1rewUQxjw07xmvL7+2U6wM64BgiXaqbGGmmnFHSF7OZ5r6hs
SAlUfekx1MwDRseigq8pjqFcwhcnCp3bINVeWJ7ITHY/t1E6LQaO5Msc09Zdf+wa
STqnQo39SqADV8nJSEQe7mEjGGHL23FgQrt8CHDi8b67oH+XGFIA/FIrOSHorLvP
WTxFPAcPFsqPs7AGSxm1fpNA2CEJ8PoLuHuVKECq7EKRmteL54s3xoO0TveLM3xZ
NA3WC1pRlsDe7I+r46+/j61K6ZBMppYabh4l0vTMmw0KtaQuAkUiRsxHDCBmKow=
=4p4M
-----END PGP SIGNATURE-----

--=-sMXnraNMJkJW9Z3JHste--

