From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [GIT PATCH] scsi updates for 2.6.12-rc2
Date: Fri, 15 Apr 2005 13:25:56 +0200
Message-ID: <20050415112556.GA6086@elf.ucw.cz>
References: <1113442034.4933.53.camel@mulgrave> <20050415103646.GB1797@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38089 "EHLO amd.ucw.cz")
	by vger.kernel.org with ESMTP id S261801AbVDOL0P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2005 07:26:15 -0400
Content-Disposition: inline
In-Reply-To: <20050415103646.GB1797@elf.ucw.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

Hi!

> > This is a small set of bugfixes for 2.6.12-rc2 ... you asked me to try
> > git, so I did (I actually updated my bk backport script simply to export
> > from a BK tree to a git tree).  For the time being, I plan to keep the
> > scsi changes in BK, but I'll export them for you to try merging
> > 
> > The patch (against kernel-test.git) is here
> > 
> > rsync://www.parisc-linux.org/~jejb/scsi-rc-fixes-2.6.git
> 
> Can you du -s on it? Just curious. I started rsync on it, but because
> it is not standard gzip files, it is difficult to see anything
> interesting...

Okay, so du -s is:

root@amd:~# du -sh /tmp/delme.git/
109M    /tmp/delme.git/

Not as bad as I expected, but still quite a lot of data for few
changes.

								Pavel
-- 
Boycott Kodak -- for their patent abuse against Java.
