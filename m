From: Jens Axboe <axboe@suse.de>
Subject: Re: [RFC PATCH 2.6.9-rc2] Add sysfs queue depth override to qla2xxx
Date: Tue, 28 Sep 2004 22:12:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928201257.GA22509@suse.de>
References: <B179AE41C1147041AA1121F44614F0B0012AD92B@AVEXCH02.qlogic.org> <20040928193614.GB192475@sgi.com> <1096401196.2008.97.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:65184 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S267776AbUI1UNX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 16:13:23 -0400
Content-Disposition: inline
In-Reply-To: <1096401196.2008.97.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeremy Higdon <jeremy@sgi.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Sep 28 2004, James Bottomley wrote:
> On Tue, 2004-09-28 at 15:36, Jeremy Higdon wrote:
> > I was trying to be conservative -- I didn't know the reason for
> > that limit.  By all means, let's remove it then.
> > 
> > Would you like me to regenerate the patch, or do you just want
> > to apply it to your internal source that will eventually be
> > fed back to us?
> 
> Well, don't go overboard on this ... there is a limit to the number of
> outstanding requests any queue can have at one time...there's not much
> point going over that since the block layer will throttle you when you
> reach it.  I think it's 128, but it might be 256 ... but anyway, not
> much larger.

That depends on both the io scheduler and the nr_requests setting, I
don't think you should rely on any imposed block layer limit.

-- 
Jens Axboe

