From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Lsf-pc] [dm-devel]  [LSF/MM TOPIC] a few storage topics
Date: Fri, 27 Jan 2012 09:34:49 +1100
Message-ID: <20120126223449.GZ15102@dastard>
References: <20120124184054.GA23227@infradead.org>
 <20120124190732.GH4387@shiny>
 <x49vco0kj5l.fsf@segfault.boston.devel.redhat.com>
 <20120124200932.GB20650@quack.suse.cz>
 <x49pqe8kgej.fsf@segfault.boston.devel.redhat.com>
 <20120124203936.GC20650@quack.suse.cz>
 <20120125032932.GA7150@localhost>
 <F6F2DEB8-F096-4A3B-89E3-3A132033BC76@dilger.ca>
 <20120125063552.GA27375@localhost>
 <20120126162555.GF1891@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:41012 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515Ab2AZWew (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2012 17:34:52 -0500
Content-Disposition: inline
In-Reply-To: <20120126162555.GF1891@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Wu Fengguang <fengguang.wu@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, "neilb@suse.de" <neilb@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Chris Mason <chris.mason@oracle.com>, "Darrick J.Wong" <djwong@us.ibm.com>

On Thu, Jan 26, 2012 at 11:25:56AM -0500, Vivek Goyal wrote:
> On Wed, Jan 25, 2012 at 02:35:52PM +0800, Wu Fengguang wrote:
> > > It would also be
> > > possible to trigger on the size of the device so that the 32MB USB stick
> > > doesn't sit busy for a minute with readahead that is useless.
> > 
> > Yeah, I do have a patch for shrinking readahead size based on device size.
> 
> Should it be a udev rule to change read_ahead_kb on device based on device
> size, instead of a kernel patch?

That's effectively what vendors like SGI have been doing since udev
was first introduced, though more often the rules are based on device
type rather than size. e.g. a 64GB device might be a USB flash drive
now, but a 40GB device might be a really fast SSD....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
