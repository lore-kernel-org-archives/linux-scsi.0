From: Jamie Lenehan <lenehan@twibble.org>
Subject: Re: dc395x: CD writer causes endless "sg_to_virt failed" loop
Date: Wed, 7 Apr 2004 00:01:23 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040406140123.GA9884@twibble.org>
References: <20040327161034.GA9963@twibble.org> <200403271759.08361.andrex@alumni.utexas.net> <200404050120.56111.andrex@alumni.utexas.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:34784 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S263823AbUDFOB3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 10:01:29 -0400
Content-Disposition: inline
In-Reply-To: <200404050120.56111.andrex@alumni.utexas.net>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Schulman <andrex@alumni.utexas.net>
Cc: linux-scsi@vger.kernel.org, dc395x@twibble.org

On Mon, Apr 05, 2004 at 01:20:56AM -0400, Andrew Schulman wrote:
> > First thing to try would be to upgrade to 2.6.5-rc1 (or newer) and
> > see if that works any better.
> 
> I'm now running kernel 2.6.5.  The good news is that my CD writer (HP 9200i) 
> works again.  The bad news is that I'm still getting e.g.
> 
> Apr  5 00:46:50 helium kernel: dc395x: sg_update_list: sg_to_virt failed
> Apr  5 00:47:21 helium last message repeated 576 times
> Apr  5 00:48:22 helium last message repeated 974 times
> Apr  5 00:49:23 helium last message repeated 979 times
> Apr  5 00:50:24 helium last message repeated 971 times
> Apr  5 00:51:25 helium last message repeated 970 times
> Apr  5 00:52:26 helium last message repeated 974 times
> Apr  5 00:52:40 helium last message repeated 228 times
> 
> (result of burning a CD).  This isn't great, but it's tolerable and at least 
> the CD writer works again.

Have you verified that the CD(s) were actually written correctly?
That's the one thing I'd really be concerned about. If so then you
can always just comment the message out of the source code for now.

I'll look over that code again and see if I can see why it thinks it
cannot find the address it's looking for (and if it matters).

What would be helpful (if your bored!) would be to enable the
debugging at the top of dc395x.c and do a very short run (half a
dozen copies of the message is enough, no need for 10k of them ;) and
then compress the logs and put them somewhere I can grab them (or
e-mail them if < 5MB).

Thanks.

-- 
 Jamie Lenehan <lenehan@twibble.org>
