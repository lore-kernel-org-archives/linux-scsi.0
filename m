From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] scsi: Document generic scsi device attributes
Date: Thu, 18 Aug 2011 14:47:02 +0200
Message-ID: <20110818144702.1b2e4616@stein>
References: <20110817182055.8848.75862.stgit@beardog.cce.hp.com>
	<1313610306.6345.4.camel@mulgrave>
	<20110817200028.GB8422@beardog.cce.hp.com>
	<1313613307.6345.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1313613307.6345.8.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: scameron@beardog.cce.hp.com, stephenmcameron@gmail.com, akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Aug 17 James Bottomley wrote:
> On Wed, 2011-08-17 at 15:00 -0500, scameron@beardog.cce.hp.com wrote:
> > On Wed, Aug 17, 2011 at 12:45:06PM -0700, James Bottomley wrote:
> > > On Wed, 2011-08-17 at 13:20 -0500, Stephen M. Cameron wrote:
> > > > +++ b/Documentation/ABI/testing/sysfs-class-scsi_devices
> > > > @@ -0,0 +1,123 @@
> > > > +What:           /sys/class/scsi_device/..../device/device_blocked
> > > > +Date:           December, 2002
> > > > +KernelVersion:  Unknown
> > > > +Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
> > > 
> > > Hmm, so I get fingered for every screw up in our sysfs ABI? nice wide
> > > receiver buck pass move.
> > 
> > Uh, sorry if that wasn't the right thing to do, which it sounds
> > like it wasn't.  I just put your name there because you're the SCSI
> > maintainer.  I can dig through all the commits and see who added what
> > if that's preferable.  Or leave the names out?  or something else?
> 
> No, don't worry, the patch is the right thing to do ... I was just
> slightly amused to see my name down for all of it.

Isn't linux-scsi@vger.kernel.org acceptable if not even preferable
as contact?
-- 
Stefan Richter
-=====-==-== =--- =--=-
http://arcgraph.de/sr/
