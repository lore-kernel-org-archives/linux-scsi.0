From: Jens Axboe <axboe@suse.de>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: Fri, 11 Jun 2004 11:24:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040611092416.GU13836@suse.de>
References: <1086798154.7074.24.camel@patibmrh9> <1086805796.3741.5.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:58053 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262322AbUFKJY2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2004 05:24:28 -0400
Content-Disposition: inline
In-Reply-To: <1086805796.3741.5.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Wed, Jun 09 2004, Pat LaVarre wrote:
> Jens A:
> 
> > a) kernel.org 2.6.7-rc3 plus the patch of this thread,
> > b) PATAPI drive connected as /dev/hdd,
> > c) open of /dev/hdd with flags O_NONBLOCK|O_RDWR, ioctl SG_IO
> > d) cdb = x 1B 00:00:00 00 00 // Stop
> > e) cdb = x 1B 00:00:00 01 00 // Start
> 
> Yes now "Hn" (i.e. expecting no data) works here, every time I try.

Good

> > For data transfer, it's more tricky. Well actually, if you restrict
> > yourself to non-bio backed request, then it becomes pretty trivial!
> > ide-floppy expects a contig buffer, a bio is scattered by nature.
> 
> Yes "Hi" (i.e. expecting data in) gives me zeroes.

Not so good... I'll take a 2nd look and get you something to test,
unfortunately I cannot test here as I have no atapi floppy drives.

-- 
Jens Axboe

