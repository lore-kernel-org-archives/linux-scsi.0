From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
Subject: Re: [PATCH] [TRIVIAL] Remove braces in drivers/scsi/in2000.h to fix build for clang. No functional change otherwise.
Date: Wed, 21 Aug 2013 15:11:33 +0200
Message-ID: <4059776.Z90q7kXsSC@aragorn.auenland.lan>
References: <1377033546-19475-1-git-send-email-dl9pf@gmx.de> <20130821065018.GB9043@infradead.org> <2050670.KsM0dPm3or@aragorn.auenland.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2050670.KsM0dPm3or@aragorn.auenland.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: PaX Team <pageexec@freemail.hu>, Behan Webster <behanw@converseincode.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 21 August 2013 09:26:14 Jan-Simon M=F6ller wrote:
> > > Description:
> > >   Clang chokes on the notation "insw (%%dx)" but works for "insw =
%%dx"
> > >   (outsw likewise); GNU as accepts both forms.
> > >=20
> > > Signed-off-by: Jan-Simon M??ller <dl9pf@gmx.de>
> >=20
> > I think the right fix is to simply kill the FAST_READ_IO/FAST_WRITE=
_IO
> > defines and their associated inline assembly entirely.
>=20
> No objection ;) .
@Christoph Hellwig:
Do you take care of removing it then ?

BR,
JS
