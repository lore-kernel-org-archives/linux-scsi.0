From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/3] scsi: add hooks for host runtime power management
Date: Thu, 3 Nov 2011 11:39:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1111031139150.2136-100000@iolanthe.rowland.org>
References: <CAOS58YNNx7XOGov19_hucAQYvw88F2YO+KoVpn8uD+COgJRbEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAOS58YNNx7XOGov19_hucAQYvw88F2YO+KoVpn8uD+COgJRbEw@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 3 Nov 2011, Tejun Heo wrote:

> Hello,
>=20
> On Thu, Nov 3, 2011 at 7:37 AM, Lin Ming <ming.m.lin@intel.com> wrote=
:
> >> Yes, it is a problem. =A0But it looks like the underlying issue is=
 that
> >> you're using the SCSI error handler to do something it was not int=
ended
> >> for. =A0Can't you suspend and resume the ATA port without using th=
e error
> >> handler?
> >
> > The system suspend and resume of the ATA port uses the error handle=
r.
> > I think the runtime suspend and resume should use the error handler=
 too.
> >
> > Tejun,
> >
> > Could you comment more on this?
>=20
> I don't know. I haven't really thought about it but as it's currently
> designed, I don't think it'll be possible to avoid going through EH t=
o
> put ATA ports into suspend mode.

Why not?

Alan Stern

