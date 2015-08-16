From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Bug 101011] Kernel Oops when disconnecting a mounted ext4 usb
 stick
Date: Sun, 16 Aug 2015 09:38:00 -0400
Message-ID: <20150816133800.GC3825@thunk.org>
References: <bug-101011-11613@https.bugzilla.kernel.org/>
 <bug-101011-11613-PGvplgVz20@https.bugzilla.kernel.org/>
 <20150814183931.GA3050@thunk.org>
 <20150815081902.GA20587@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32792 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbbHPNiJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Aug 2015 09:38:09 -0400
Content-Disposition: inline
In-Reply-To: <20150815081902.GA20587@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org, Tejun Heo <tj@kernel.org>

On Sat, Aug 15, 2015 at 10:19:02AM +0200, Christoph Hellwig wrote:
> 
> sorry for the delay - I saw the mail Jan Cc'ed me on yesterday.  After
> my changes it should not go away and I had tested the original eject
> test that it indeed didn't.  Either I forgot a case, or the major
> writeback Tejun did a little later regressed it.
> 
> As I won't have time to look into it ASAP I'd suggest to revert my
> patch for now.  In the long run I really don't want to have these
> checks spread over file system so I plan to look into it once I
> get a few spare hours.

Thanks, I'll revert the patch.

I suspect we should add an ioctl to simulate a USB device unplug using
the loopback block device, so we can add a test to xfstests.

    	     	   	      	     	 - Ted
