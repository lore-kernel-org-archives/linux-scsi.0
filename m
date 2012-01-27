From: Wu Fengguang <fengguang.wu@gmail.com>
Subject: Re: [Lsf-pc] [dm-devel]  [LSF/MM TOPIC] a few storage topics
Date: Fri, 27 Jan 2012 11:27:34 +0800
Message-ID: <20120127032734.GA16980@localhost>
References: <20120124190732.GH4387@shiny>
 <x49vco0kj5l.fsf@segfault.boston.devel.redhat.com>
 <20120124200932.GB20650@quack.suse.cz>
 <x49pqe8kgej.fsf@segfault.boston.devel.redhat.com>
 <20120124203936.GC20650@quack.suse.cz>
 <20120125032932.GA7150@localhost>
 <F6F2DEB8-F096-4A3B-89E3-3A132033BC76@dilger.ca>
 <20120125063552.GA27375@localhost>
 <20120126162555.GF1891@redhat.com>
 <20120126223449.GZ15102@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50608 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2A0D1u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jan 2012 22:27:50 -0500
Content-Disposition: inline
In-Reply-To: <20120126223449.GZ15102@dastard>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andreas Dilger <adilger@dilger.ca>, Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, "neilb@suse.de" <neilb@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Chris Mason <chris.mason@oracle.com>, "Darrick J.Wong" <djwong@us.ibm.com>

On Fri, Jan 27, 2012 at 09:34:49AM +1100, Dave Chinner wrote:
> On Thu, Jan 26, 2012 at 11:25:56AM -0500, Vivek Goyal wrote:
> > On Wed, Jan 25, 2012 at 02:35:52PM +0800, Wu Fengguang wrote:
> > > > It would also be
> > > > possible to trigger on the size of the device so that the 32MB USB stick
> > > > doesn't sit busy for a minute with readahead that is useless.
> > > 
> > > Yeah, I do have a patch for shrinking readahead size based on device size.
> > 
> > Should it be a udev rule to change read_ahead_kb on device based on device
> > size, instead of a kernel patch?
> 
> That's effectively what vendors like SGI have been doing since udev
> was first introduced, though more often the rules are based on device
> type rather than size. e.g. a 64GB device might be a USB flash drive
> now, but a 40GB device might be a really fast SSD....

Fair enough. I'll drop this kernel policy patch 

        block: limit default readahead size for small devices
        https://lkml.org/lkml/2011/12/19/89

Thanks,
Fengguang
