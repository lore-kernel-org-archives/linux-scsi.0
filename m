From: Peter Abrahamsen <peidran@u.washington.edu>
Subject: PERC 3/Di broken 2.6.6-mm5 -> 2.6.7-rc1-mm1
Date: Mon, 28 Jun 2004 15:56:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040628225601.GA8439@hugo.amandrai.net>
Reply-To: peidran@u.washington.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn8.ischool.washington.edu ([128.208.131.228]:17030 "EHLO
	amandrai.net") by vger.kernel.org with ESMTP id S265270AbUF1Wzy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jun 2004 18:55:54 -0400
Received: from peidran by amandrai.net with local (Exim 4.33)
	id 1Bf52f-0002Gz-HA
	for linux-scsi@vger.kernel.org; Mon, 28 Jun 2004 15:56:01 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Good day,

This seemed like the most proper place to report this; please let me know if
it is not.

I have a production DELL PowerEdge 2650 (PERC 3/Di) which I just tried to
upgrade from 2.4.23 to 2.6.7. I had 48 hours to back up a lot of data, do
the kernel upgrade, upgrade packages, and swap some filesystems to XFS, and
restore, so I was only able to get limited information about the problems I
encountered. Here's what I was able to find:

Environment: 2x 2.2 GHZ XEON (HT) processors, 2GB phys RAM, 5x 73 GB Quantum
drives in RAID 5 and split into two logical drives. The latest BIOS and
firmwares from DELL.

- Vanilla 2.6.* boots, but either does not recognize the controller, or does
not recognize the drives. It's hard to tell, because the keyboard was also
unresponsive, so I couldn't scroll up. If I had had more time, I should have
used serial console.

- 2.6.4-mm1, copied from another production 2650 works great.

- 2.6.6-mm5 also works fine. It looks like the last -mm kernel before major
aacraid changes were introduced in 2.6.7-rc1-mm1.

- 2.6.7-mm3 boots, but hangs on the aacraid driver. It's possible I just
didn't give it long enough (maybe a minute?). I don't think the keyboard
worked then, either (what's with that?).

So, the system's back up running 2.6.6-mm5. I don't have any experimental
systems at the moment, unfortunately, but I thought I'd give this heads-up
that aacraid seems broken recently.

BTW, when I read that some new patch was committed, where was it committed
to? Is there a cvs/svn/bk repository somewhere?

Thanks,

Peter

-- 
Peter Abrahamsen, Seattle, Washington, USA
Systems Administrator,
University of Washington Information School
