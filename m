From: Jens Axboe <axboe@suse.de>
Subject: Re: aic7xxx kobject crap
Date: Tue, 27 Apr 2004 18:07:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040427160741.GB764@suse.de>
References: <20040427141401.GF2089@suse.de> <20040427160304.GA20664@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:17882 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264195AbUD0QHo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 12:07:44 -0400
Content-Disposition: inline
In-Reply-To: <20040427160304.GA20664@kroah.com>
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, "Justin T. Gibbs" <gibbs@scsiguy.com>

On Tue, Apr 27 2004, Greg KH wrote:
> On Tue, Apr 27, 2004 at 04:14:01PM +0200, Jens Axboe wrote:
> > Hi,
> > 
> > I've given up trying to follow the kobject stuff going on in the driver
> > model, it's just one big maze of container_of() and foo_get() functions.
> > Loading the aic7xxx module gives a nice oops:
> 
> That's wierd, I'll go try to duplicate it.  Had you previously loaded
> and then unloaded the same module?  Do you have a aic7xxx device in the
> system at the time you loaded it?  Any other hints on how to duplicate
> it?

I wish I could say more, I'll have to ask to get more info. All I know
is that it happens during install. So my current assumption is that it
happens the very first time the module is loaded, and the machine does
have some sort of aic7xxx device attached (or onboard). I'll get
confirmation on that.

-- 
Jens Axboe

