From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 2/3] [SCSI]: runtime resume parent for child's
 system-resume
Date: Thu, 15 Dec 2011 02:31:52 +0800
Message-ID: <1323887512.7655.3.camel@hp6530s>
References: <Pine.LNX.4.44L0.1112141150520.1707-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1112141150520.1707-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-12-15 at 00:51 +0800, Alan Stern wrote:
> On Wed, 14 Dec 2011, Lin Ming wrote:
>=20
> > On Wed, Dec 14, 2011 at 11:18 AM, Lin Ming <ming.m.lin@intel.com> w=
rote:
> > > [Patch description from Alan Stern]
> > >
> > > If a child device was runtime-suspended when a system suspend beg=
an,
> > > then there will be nothing to prevent its parent from
> > > runtime-suspending as soon as it is woken up during the system re=
sume.
> > > Then when the time comes to resume the child, the resume will fai=
l
> > > because the parent is already back at low power.
> > >
> > > On the other hand, there are some devices which should remain at =
low
> > > power across an entire suspend-resume cycle. =EF=BF=BDThe details=
 depend on the
> > > device and the platform.
> > >
> > > This suggests that the PM core is not the right place to solve th=
e
> > > problem. =EF=BF=BDOne possible solution is for the subsystem or d=
evice driver
> > > to call pm_runtime_get_sync(dev->parent) at the start of the
> > > system-resume procedure and pm_runtime_put_sync(dev->parent) at t=
he
> > > end.
> > >
> > > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> >=20
> > Hi Alan,
> >=20
> > May I add your SOB?
>=20
> You can add: Acked-by: Alan Stern <stern@rowland.harvard.edu>
>=20
> Did you test this?  Does it do what you want?

Yes, I have tested this and it fixes the problem.

Thanks.

>=20
> Alan Stern
>=20


