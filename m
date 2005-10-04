From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Mon, 3 Oct 2005 23:30:49 -0700 (PDT)
Message-ID: <Pine.LNX.4.10.10510032319070.410-100000@master.linux-ide.org>
References: <1128377075.23932.5.camel@ryan2.internal.autoweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932392AbVJDGds@vger.kernel.org>
In-Reply-To: <1128377075.23932.5.camel@ryan2.internal.autoweb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryan Anderson <ryan@autoweb.net>
Cc: Tomasz =?iso-8859-2?Q?K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>, Luben Tuikov <luben_tuikov@adaptec.com>, andrew.patterson@hp.com, Marcin Dalecki <dalecki.marcin@neostrada.pl>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, dougg@torque.net, Linus Torvalds <torvalds@osdl.org>, Luben Tuikov <ltuikov@yahoo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Mon, 3 Oct 2005, Ryan Anderson wrote:

> On Mon, 2005-10-03 at 23:26 +0200, Tomasz K=B3oczko wrote:
> > If (cytation from Linus) "a 'spec' is close to useless" ..
> > Q: why the hell in kernel tree is included Documentation/ subdirect=
ory ?
> > Is it raly content of this directory is "close to useless" or maybe=
 it not
> > contains some specyfications ? :>
>=20
> Let me rephrase what Linus said, to help remove the misreading that
> seems so common today.  I think a fair rewording would be, "A spec is=
 a
> guideline.  When it fails to match reality, continuing to follow it i=
s a
> tremendous mistake."
>=20
> Additionally, I think the overall LKML feeling on hardware specs and =
the
> corresponding software abstractions to deal with it can be summarized
> something like this:
>=20
> When the spec provides a software design that doesn't fit into the
> overall structure of the Linux kernel, the spec should be treated as =
a
> suggestion for a software design.  The *interface* that the spec
> documents should be followed, where it moves out of the overall
> structure, but internally, a design that fits into the Linux kernel i=
s
> more important than following a spec that doesn't fit.

Please lets design against the transport or FSM of the storage transpor=
t
and never see data again.  NCITS specs generally (used loosely) define =
the
boundary conditions for stable operations.  One of jewels of linux in t=
he
past which (hopefully was fixed, was 1.2.X-2.5.X thingy) was buffer_hea=
d
walking and release to satisfy transfer of data-blocks of a spindle
against the data-blocks of the kernel.  Spindle must win or one can not
insure data integrity, thus the advent of BIO's from BH.

Linux changed to conform to data integrity issues.

Somedays, Linux's API's or designs are OTS (Over The Shoulder).

You get crap all over your back, if you reach OTS to finish your washro=
om
business.  It is functional but ends up stinky and messy.

This thread is getting longer and I just added to piles ...

Sigh

Andre
