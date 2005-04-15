From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] scsi updates for 2.6.12-rc2
Date: Fri, 15 Apr 2005 09:08:03 -0500
Message-ID: <1113574084.5009.1.camel@mulgrave>
References: <1113442034.4933.53.camel@mulgrave>
	 <20050415103646.GB1797@elf.ucw.cz>  <20050415112556.GA6086@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:6330 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261822AbVDOOIV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2005 10:08:21 -0400
In-Reply-To: <20050415112556.GA6086@elf.ucw.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Fri, 2005-04-15 at 13:25 +0200, Pavel Machek wrote:
> Okay, so du -s is:
> 
> root@amd:~# du -sh /tmp/delme.git/
> 109M    /tmp/delme.git/
> 
> Not as bad as I expected, but still quite a lot of data for few
> changes.

Erm, but that's why it's an rsync archive.  You're supposed to have a
copy of the kernel archive already.  The one at

rsync://www.kernel.org/pub/linux/kernel/people/torvalds/kernel-test.git

Then, the few additional files I have rsync across very fast.

Take a look at how git works:  files, once added to the object tree by
sha1 hash stay there forever.

James


