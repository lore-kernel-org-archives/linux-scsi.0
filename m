From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH] scsi: Document generic scsi device attributes
Date: Wed, 17 Aug 2011 15:00:28 -0500
Message-ID: <20110817200028.GB8422@beardog.cce.hp.com>
References: <20110817182055.8848.75862.stgit@beardog.cce.hp.com> <1313610306.6345.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:46519 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab1HQUAa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 16:00:30 -0400
Content-Disposition: inline
In-Reply-To: <1313610306.6345.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Aug 17, 2011 at 12:45:06PM -0700, James Bottomley wrote:
> On Wed, 2011-08-17 at 13:20 -0500, Stephen M. Cameron wrote:
> > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > 
> > Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > ---
> >  Documentation/ABI/testing/sysfs-class-scsi_devices |  123 ++++++++++++++++++++
> >  1 files changed, 123 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/ABI/testing/sysfs-class-scsi_devices
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-class-scsi_devices b/Documentation/ABI/testing/sysfs-class-scsi_devices
> > new file mode 100644
> > index 0000000..ad2d36b
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-class-scsi_devices
> > @@ -0,0 +1,123 @@
> > +What:           /sys/class/scsi_device/..../device/device_blocked
> > +Date:           December, 2002
> > +KernelVersion:  Unknown
> > +Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> Hmm, so I get fingered for every screw up in our sysfs ABI? nice wide
> receiver buck pass move.

Uh, sorry if that wasn't the right thing to do, which it sounds
like it wasn't.  I just put your name there because you're the SCSI
maintainer.  I can dig through all the commits and see who added what
if that's preferable.  Or leave the names out?  or something else?

-- steve

