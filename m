From: Greg KH <greg@kroah.com>
Subject: Re: aic7xxx kobject crap
Date: Tue, 27 Apr 2004 09:03:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040427160304.GA20664@kroah.com>
References: <20040427141401.GF2089@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([65.200.24.183]:5032 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S262930AbUD0QD1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 12:03:27 -0400
Content-Disposition: inline
In-Reply-To: <20040427141401.GF2089@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org, "Justin T. Gibbs" <gibbs@scsiguy.com>

On Tue, Apr 27, 2004 at 04:14:01PM +0200, Jens Axboe wrote:
> Hi,
> 
> I've given up trying to follow the kobject stuff going on in the driver
> model, it's just one big maze of container_of() and foo_get() functions.
> Loading the aic7xxx module gives a nice oops:

That's wierd, I'll go try to duplicate it.  Had you previously loaded
and then unloaded the same module?  Do you have a aic7xxx device in the
system at the time you loaded it?  Any other hints on how to duplicate
it?

thanks,

greg k-h
