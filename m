From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH]:Amended:Allow random write for PDT 5 profile 2 Removable Disk
Date: Sun, 7 Mar 2004 12:45:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040307114507.GJ23525@suse.de>
References: <1078593406.2006.4.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:4536 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261813AbUCGLpZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Mar 2004 06:45:25 -0500
Content-Disposition: inline
In-Reply-To: <1078593406.2006.4.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: mckellj@iomega.com, linux-scsi@vger.kernel.org

On Sat, Mar 06 2004, Pat LaVarre wrote:
> > queued it for 2.6.4-pre
> 
> Absent from 2.6.4-rc2, I think.

Will most likely have to wait for 2.6.5-pre/rc

> Perhaps if I knew what -pre meant that would be no surprise to me.

I'm not sure how I can even express that any clearer...

> http://marc.theaimsgroup.com/?l=linux-scsi&s=random+write+pdt+5
> does not yet enlighten me further, but I observe lk refusing to let Me
> write:
> 
> $ uname -msrv
> Linux 2.6.4-rc2 #1 SMP Sat Mar 6 09:58:43 MST 2004 i686
> $
> $ grep CDF_ include/linux/cdrom.h
> #define CDF_MRW         0x28
> $ grep -i HWDM include/linux/cdrom.h
> $
> $ sudo rrd scan
> /dev/scd0 is Iomega RRD 06.3 rw
> /dev/hdc is Iomega RRD 06.3 rw
> $
> $ sudo dd of=/dev/null if=/dev/scd0 bs=64K seek=0 skip=0 count=1
> 1+0 records in
> 1+0 records out
> $ sudo dd of=/dev/null if=/dev/hdc bs=64K seek=0 skip=0 count=1
> 1+0 records in
> 1+0 records out
> $
> $ sudo dd of=/dev/scd0 if=/dev/zero bs=64K seek=0 skip=0 count=1
> dd: opening `/dev/scd0': Read-only file system
> $ sudo dd of=/dev/hdc if=/dev/zero bs=64K seek=0 skip=0 count=1
> dd: opening `/dev/hdc': Read-only file system
> $

Is there some other point to the above than stating that the required
patch hasn't been merged? Feel free to resend.

-- 
Jens Axboe

