From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [RFC] SCSI Hotplug for lk 2.5
Date: Fri, 2 Aug 2002 17:20:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0208021719070.66805-100000@beppo>
References: <17amcn-1uCpTkC@fmrl06.sul.t-online.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <17amcn-1uCpTkC@fmrl06.sul.t-online.com>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <Oliver.Neukum@lrz.uni-muenchen.de>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org



On Sat, 3 Aug 2002, Oliver Neukum wrote:

> Am Freitag, 2. August 2002 23:21 schrieb Matthew Jacob:
> > > It would be really nice if a low-level driver could signal, somehow, to
> > > the VFS layer that it was a hot-unpluggable device, and thus precautions
> > > should be taken (i.e. perfer mounting with -o sync, etc.)
> >
> > I don't think this s wise. By definition all SAN devices are
> > 'hot-unpluggable', and you sure don't want to mount them sync only.
> 
> Other measures, eg preperation to handle replugging could so be shifted
> up. There's nothing lost be exporting it and some to gain.

You don't necessarily have predictive control over hotplugging.

> OTOH this might be better placed in driverfs than in hotplug.

I'd been given this some thought for a while, but I don't have a good
answer. Perhaps an 'involuntary hotplug' event, as opposed to a 'voluntary'
one is needed. I dunno.


