From: Jens Axboe <axboe@suse.de>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: Wed, 9 Jun 2004 19:37:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040609173728.GA20975@suse.de>
References: <20040609082045.GT13836@suse.de> <1086798154.7074.24.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:48264 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265798AbUFIRhd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2004 13:37:33 -0400
Content-Disposition: inline
In-Reply-To: <1086798154.7074.24.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Wed, Jun 09 2004, Pat LaVarre wrote:
> > Hmm fudge.
> 
> Sorry, this English I do not understand.
> 
> > --- 1.149/drivers/ide/ide.c     2004-06-04 21:14:59 +02:00
> > +++ edited/drivers/ide/ide.c    2004-06-09 10:07:46 +02:00
> 
> Patch!  Cool, thank you.
> 
> > Pat, can you test
> 
> Gladly.  Unless redirected, I will try combining:
> 
> a) kernel.org 2.6.7-rc3 plus the patch of this thread,
> b) PATAPI drive connected as /dev/hdd,
> c) open of /dev/hdd with flags O_NONBLOCK|O_RDWR, ioctl SG_IO
> d) cdb = x 1B 00:00:00 00 00 // Stop
> e) cdb = x 1B 00:00:00 01 00 // Start

f) issue some command that transfers data as well.

if you use the 2nd patch I posted.

-- 
Jens Axboe

