From: Jens Axboe <axboe@suse.de>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: Sun, 13 Jun 2004 21:58:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040613195809.GA2566@suse.de>
References: <20040611093815.GX13836@suse.de> <1087152503.3172.11.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:34505 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265257AbUFMT6V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jun 2004 15:58:21 -0400
Content-Disposition: inline
In-Reply-To: <1087152503.3172.11.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Sun, Jun 13 2004, Pat LaVarre wrote:
> > > should work, I think.
> 
> Yes, thank you!
> 
> I reverted drivers/ide/ide.c ide-floppy.c to 2.6.7-rc3 and then saw your
> updated version applied clean.
> 
> > Here's an updated version.
> 
> For me now ioctl SG_GET_VERSION_NUM works, and ioctl SG_IO works, ...

Super!

> Except ioctl SG_IO sg_io_hdr_t.resid always comes back unchanged from
> its initial dxfer_len value.  I see nonzero residue reported by the
> trivial code I mentioned before, same there as in plscsi.

That's expected, I need to change the callback to set these correctly
(it's not modifying any of the sg_io_hdr output values in the test
patch). I'll try and get you a patch tomorrow, if you could check error
reporting + residual with that, we can get something into mainline soon.

-- 
Jens Axboe

