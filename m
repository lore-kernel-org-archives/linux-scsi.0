From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Sat, 14 Dec 2002 16:29:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4011340000.1039908562@aslan.scsiguy.com>
References: <20021214223934.P3547-100000@localhost.my.domain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021214223934.P3547-100000@localhost.my.domain>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>, Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

> Btw, people who want to learn about how to design and maintain a smar=
t
> driver interface that can evolve gracefully without breaking driver
> zillions of times should ask Justin how it does this so well with
> FreeBSD/CAM, in my opinion.
>=20
>   G=E9rard.

Gerard,

The whole reason CAM has been sucessful was that the decision was made,
however painful it was, to completely redo a subsystem to fix the blate=
nt
architectural flaws in it.  CAM was only integrated once all of the dri=
vers
were ported and it had received extensive external testing.  I don't kn=
ow
that I or anyone else can do much better with the Linux SCSI layer unti=
l
such time that someone decides to just nuke the whole thing and start o=
ver.
A hack, on top of a hack, on top of a hack is no way to build a solid=20
foundation.  What's even more frustrating for me is that the hacks show=
 up
in places you never expect and in forms that don't warn you if you are =
out
of compliance with the "new hack".  It makes it very difficult to follo=
w
interface changes successfully.

--
Justin

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
