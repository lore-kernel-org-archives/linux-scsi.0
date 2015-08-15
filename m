From: Christoph Hellwig <hch@lst.de>
Subject: Re: [Bug 101011] Kernel Oops when disconnecting a mounted ext4 usb
	stick
Date: Sat, 15 Aug 2015 10:19:02 +0200
Message-ID: <20150815081902.GA20587@lst.de>
References: <bug-101011-11613@https.bugzilla.kernel.org/> <bug-101011-11613-PGvplgVz20@https.bugzilla.kernel.org/> <20150814183931.GA3050@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55682 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbbHOITE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Aug 2015 04:19:04 -0400
Content-Disposition: inline
In-Reply-To: <20150814183931.GA3050@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org, Tejun Heo <tj@kernel.org>

Hi Ted,


sorry for the delay - I saw the mail Jan Cc'ed me on yesterday.  After
my changes it should not go away and I had tested the original eject
test that it indeed didn't.  Either I forgot a case, or the major
writeback Tejun did a little later regressed it.

As I won't have time to look into it ASAP I'd suggest to revert my
patch for now.  In the long run I really don't want to have these
checks spread over file system so I plan to look into it once I
get a few spare hours.
