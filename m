From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] gdth: Stop abusing ->done for internal commands
Date: Tue, 25 Sep 2007 11:33:37 -0600
Message-ID: <20070925173337.GX10625@parisc-linux.org>
References: <1190738524460-git-send-email-willy@linux.intel.com> <1190738524757-git-send-email-willy@linux.intel.com> <46F945B5.2030305@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59210 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbXIYRdi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 13:33:38 -0400
Content-Disposition: inline
In-Reply-To: <46F945B5.2030305@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org

On Tue, Sep 25, 2007 at 07:30:29PM +0200, Boaz Harrosh wrote:
> OK This is on top of the first patch that I will take care of,
> right? (http://www.spinics.net/lists/linux-scsi/msg19470.html)

That's right.

> Here 2 it will not merge with my patchset. So I'll take it off your hands
> and rebase it to mine.

Wonderful.  Again, I don't care about this driver, just want it to not
break (more than it's already broken).

> In my patchset I have introduced a gdth_cmnd_priv. That is associated
> with every command and is put on cmnd->host_scribble, I than moved lots
> of abused Scp and other members to that new structure. I also put a 
> simple boolean that states that these are Internal commands. So what
> is left of this patch is the:
> -    scp->done = gdth_scsi_done;
> I will add that one line removal to your previous patch.

Excellent.  Makes perfect sense.

> > Ah; I was basing this on linus + scsi-misc.  I guess scsi_lib hadn't
> > been converted because I just took the code from there.
> Yes scsi_lib was not converted, but scsi.c was.

OK.  I've converted that in my tree now, and fixed a small whitespace
error I introduced.  I'll wait for more comments before posting a
replacement patch.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
