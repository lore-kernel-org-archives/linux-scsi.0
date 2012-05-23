From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH v3 0/4]: block layer runtime pm
Date: Wed, 23 May 2012 11:27:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205231124460.1566-100000@iolanthe.rowland.org>
References: <CAF1ivSYTw19AEXmhAsvXp-vVk5ZGeFPzi9omBzCtYGKixNS5xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSYTw19AEXmhAsvXp-vVk5ZGeFPzi9omBzCtYGKixNS5xw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 23 May 2012, Lin Ming wrote:

> On Wed, May 23, 2012 at 11:03 PM, Alan Stern <stern@rowland.harvard.e=
du> wrote:
> > On Wed, 23 May 2012, Lin Ming wrote:
> >
> >> Another thing need to check is if system suspend/resume works.
> >
> > Right! =A0Although I would hope that your work doesn't interfere at=
 all
> > with system sleep, since it touches only the runtime PM pathways.
>=20
> sd_sync_cache and sd_start_stop_device are changed with REQ_PM set.
> And they are called for system suspend too.
>=20
> So it probably will have problem.

People have already run into problems where system suspend=20
occurred at a time when a SCSI device was already runtime suspended. =20
That's why scsi_bus_suspend_common() includes an appropriate check.

Alan Stern
