From: Jens Axboe <axboe@suse.de>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: Fri, 11 Jun 2004 11:24:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040611092458.GV13836@suse.de>
References: <1086805796.3741.5.camel@patibmrh9> <1086807083.3741.21.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:9926 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262361AbUFKJZH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2004 05:25:07 -0400
Content-Disposition: inline
In-Reply-To: <1086807083.3741.21.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Wed, Jun 09 2004, Pat LaVarre wrote:
> > Also something's broken (far far outside of the kernel) in plscsi.  I
> > found success only by patching the trivial sgio.c that I posted in this
> > thread, as shown below.
> 
> Ah. That is, despite the patch inserting idefloppy_blockpc_cmd,
> 
> ioctl(fd, SG_GET_VERSION_NUM, &vn) returns negative.
> 
> Pat LaVarre
> 
> P.S. More specifically,
> 
> plscsi, with perhaps excessively paranoid automagic, therefore chose not
> to try 2.4 style ioctl SG_IO, complaining:

ide.c needs the whole range of SG ioctls that block/scsi_ioctl.c
supports. I'll add that.

-- 
Jens Axboe

