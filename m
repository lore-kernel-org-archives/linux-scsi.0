From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v3 68/77] ncr5380: Fix whitespace issues using regexp
Date: Wed, 23 Dec 2015 11:56:41 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512231138330.28866@nippy.intranet>
References: <20151222011737.980475848@telegraphics.com.au>  <20151222011756.506380156@telegraphics.com.au> <1450795615.21677.10.camel@perches.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463806400-1477190481-1450831528=:28866"
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1450795615.21677.10.camel@perches.com>
Content-ID: <alpine.LNX.2.00.1512231146580.28866@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463806400-1477190481-1450831528=:28866
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.LNX.2.00.1512231146581.28866@nippy.intranet>


On Tue, 22 Dec 2015, Joe Perches wrote:

> On Tue, 2015-12-22 at 12:18 +1100, Finn Thain wrote:
> > This patch is just the result of two substitutions. The first removes=
=20
> > any tabs and spaces at the end of the line. The second replaces runs=20
> > of tabs and spaces at the beginning of comment lines with a single=20
> > space.
>=20
> I think the second of these isn't done well.

The aim of this patch is not to fix code style, but to make it possible to=
=20
compare these two files so that the fork can be repaired. Regexp is very=20
helpful in creating uniformity (and a minimal diff).

If this was a coding style issue, we would be discussing the use of=20
kernel-doc format for the affected comments, not whitespace.

> Many of these comments post reformatting are
> much worse to read because of lost alignment.

You exaggerate a very trivial point.

I admit that a small proportion of comments are slightly less readable.=20
But it is the diff that needs to be readable in order to resolve the fork.

As I said in patch 0, I am aware that this patch series can be faulted on=
=20
trivial grounds but in order to avoid churn I don't wish to address those=
=20
issues until the fork has been resolved.

Thanks for your review.

>=20
> For instance:
>=20
> > +/*
> > =A0 * Function : int NCR5380_select(struct Scsi_Host *instance,
> > - *=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0struct scsi_cmnd *cmd)
> > + * struct scsi_cmnd *cmd)
> > =A0 *
> > =A0 * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing =
command,
> > - *=A0=A0=A0=A0=A0=A0including ARBITRATION, SELECTION, and initial mess=
age out for=A0
> > - *=A0=A0=A0=A0=A0=A0IDENTIFY and queue messages.=A0
> > + * including ARBITRATION, SELECTION, and initial message out for
> > + * IDENTIFY and queue messages.
>=20

--=20
---1463806400-1477190481-1450831528=:28866--
