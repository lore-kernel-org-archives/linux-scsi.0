From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all blockpc	requests	and simplify hw handlers
Date: Tue, 7 Jun 2005 20:43:36 +0200
Message-ID: <20050607184335.GD8172@suse.de>
References: <1118162097.4813.38.camel@mulgrave> <007e01c56b90$1a09a6f0$e0019d89@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:14487 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261872AbVFGSml (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2005 14:42:41 -0400
Content-Disposition: inline
In-Reply-To: <007e01c56b90$1a09a6f0$e0019d89@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, 'Douglas Gilbert' <dougg@torque.net>, 'Mike Christie' <michaelc@cs.wisc.edu>, 'device-mapper development' <dm-devel@redhat.com>, 'linux-scsi' <linux-scsi@vger.kernel.org>, LIRANS@il.ibm.com

On Tue, Jun 07 2005, Tony Battersby wrote:
> > > My company (Cybernetics) sells several products that run embedded
> Linux
> > > which use the userspace scatter-gather capability of the SG driver.
> > > They are still running the 2.4 kernel series, but we will probably
> > > switch to 2.6 at some point.
> >
> > What do they actually use it for?  As in why is the data scattered
> even
> > in the virtual address space?
> 
> One of our products is a RAID-like controller for SCSI tape drives.
> Parallel SCSI or iSCSI in via a target-mode SCSI driver and parallel
> SCSI, iSCSI, or FC out via the SG driver, with various functions in
> between for data buffering, emulation, striping, mirroring, etc.  The
> program that controls everything has a complex internal buffering scheme
> that uses userspace scatter-gather for the main read/write I/O path to
> the tape drives.

That sounds like a valid use. Either way, I don't think we should remove
such a feature. It's a sane feature, and people might be using it -
there's no excuse for removing it.
Should we kill readv next? :)

-- 
Jens Axboe

