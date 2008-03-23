From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: Buffered I/O to block device very slow and other SCSI issues...
Date: Sun, 23 Mar 2008 16:11:13 -0700
Message-ID: <20080323231113.GC41699@sgi.com>
References: <20080319231654.GA103321673@sgi.com> <20080320010807.GA27620@sgi.com> <20080320032010.e640c52a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.171.29]:37441 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755965AbYCWXLT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Mar 2008 19:11:19 -0400
Content-Disposition: inline
In-Reply-To: <20080320032010.e640c52a.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, jes@sgi.com

On Thu, Mar 20, 2008 at 03:20:10AM -0700, Andrew Morton wrote:
> On Wed, 19 Mar 2008 18:08:07 -0700 Jeremy Higdon <jeremy@sgi.com> wrote:
> > > I also suspect that CTQ has not been set up correctly on this
> > > kernel, because:
> > > 
> > > $ cat /sys/block/sdb/device/queue_depth
> > > 3
> > > $ ls -l /sys/block/sdb/device/queue_depth
> > > -r--r--r-- 1 root root 0 Mar 20 09:59 /sys/block/sdb/device/queue_depth
> > > $
> > > 
> > > It appears to be hard coded to 3 and can't be changed....
> > 
> > That's a bug in the qla1280 driver.  I thought that had gotten fixed.
> > It's looking at the wrong mailbox register after setting device parameters.
> > 
> 
> Was there a patch anywhere?

I thought so, but maybe not.  I'll go looking for what happened and then
forward one, but it'll take a couple of weeks, unless I can get Jes to
do it, as I'm going on vacation/holiday for a week.

jeremy
