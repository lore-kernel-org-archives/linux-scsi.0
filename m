From: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Subject: Re: [PATCH][2.6.8-rc1-mm1] drivers/scsi/sg.c gcc341 inlining fix
Date: Wed, 14 Jul 2004 19:31:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200407141931.12249.bzolnier@elka.pw.edu.pl>
References: <200407141216.i6ECGHxg008332@harpo.it.uu.se> <40F562FC.50806@pobox.com> <20040714165419.GF7308@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mion.elka.pw.edu.pl ([194.29.160.35]:23758 "EHLO
	mion.elka.pw.edu.pl") by vger.kernel.org with ESMTP id S265098AbUGNRZK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2004 13:25:10 -0400
In-Reply-To: <20040714165419.GF7308@fs.tum.de>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>, Jeff Garzik <jgarzik@pobox.com>
Cc: Mikael Pettersson <mikpe@csd.uu.se>, akpm@osdl.org, dgilbert@interlog.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


FYI 'inlining fix' was just merged as part of viro's sparse cleanups

I still would like somebody to comment on idea of converting sg.c
to use standard inlines from <linux/time.h> ...

On Wednesday 14 of July 2004 18:54, Adrian Bunk wrote:
> On Wed, Jul 14, 2004 at 12:44:44PM -0400, Jeff Garzik wrote:
> > Adrian Bunk wrote:
> > >On Wed, Jul 14, 2004 at 11:52:46AM -0400, Jeff Garzik wrote:
> > >>...
> > >>If gcc is insisting that prototypes for inlines no longer work, we have
> > >>a lot of code churn on our hands ;-(  Grumble.
> > >
> > >I've counted at about 30 files with such problems in a full i386
> > >2.6.7-mm7 compile.
> > >
> > >I've already sent patches for some of them (e.g. the dmascc.c one), and
> > >they are usually pretty straightforward.
> >
> > This is not a problem with the kernel.
> >
> > All these files have been functioning just fine for years, with properly
> > prototyped static inline functions.
>
> Add -Winline to the compile flags, and name one gcc version that is able
> to inline them all in sg.c ...
>
> > Though there is a the claim that '#define inline always_inline' is
> > leading to all this breakage.
>
> gcc 3.4 is just complaining louder that it can't inline something it was
> told to inline.
>
> > 	Jeff
>
> cu
> Adrian

