From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v3 68/77] ncr5380: Fix whitespace issues using regexp
Date: Wed, 23 Dec 2015 13:03:02 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512231255350.30030@nippy.intranet>
References: <20151222011737.980475848@telegraphics.com.au>  <20151222011756.506380156@telegraphics.com.au>  <1450795615.21677.10.camel@perches.com>  <alpine.LNX.2.00.1512231138330.28866@nippy.intranet> <1450833190.3537.2.camel@perches.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463806400-989547071-1450836182=:30030"
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1450833190.3537.2.camel@perches.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463806400-989547071-1450836182=:30030
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Tue, 22 Dec 2015, Joe Perches wrote:

> On Wed, 2015-12-23 at 11:56 +1100, Finn Thain wrote:
> > On Tue, 22 Dec 2015, Joe Perches wrote:
> >=20
> > > On Tue, 2015-12-22 at 12:18 +1100, Finn Thain wrote:
> > > > This patch is just the result of two substitutions. The first=20
> > > > removes any tabs and spaces at the end of the line. The second=20
> > > > replaces runs of tabs and spaces at the beginning of comment lines=
=20
> > > > with a single space.
> > >=A0
> > > I think the second of these isn't done well.
> >=20
> > The aim of this patch is not to fix code style, but to make it=20
> > possible to compare these two files so that the fork can be repaired.=
=20
> > Regexp is very helpful in creating uniformity (and a minimal diff).
> >=20
> > If this was a coding style issue, we would be discussing the use of=20
> > kernel-doc format for the affected comments, not whitespace.
> >=20
> > > Many of these comments post reformatting are much worse to read=20
> > > because of lost alignment.
> >=20
> > You exaggerate a very trivial point.
>=20
> <shrug>
>=20
> I prefer that all patches be improvements.
>=20

Agreed. But the example you cited is an improvement, in that it creates=20
consistency.

Like you, I prefer to see formal parameters aligned when wrapped. But this=
=20
isn't a formal parameter list, it is a comment, and no comment should=20
duplicate code.

Can you suggest a better regexp? Since this is patch 68 in the series,=20
there is a good chance that it will need to be regenerated.

> > I admit that a small proportion of comments are slightly less=20
> > readable. But it is the diff that needs to be readable in order to=20
> > resolve the fork.
>=20
> diff -w works well.
>=20

Yes, it works well at times. For this I prefer to use meld. It does have=20
text filters that allow the user to elide differences that match a given=20
regexp. But I don't want every meld user to have to write those regexps.

--=20
---1463806400-989547071-1450836182=:30030--
