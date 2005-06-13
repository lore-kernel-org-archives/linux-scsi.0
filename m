From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] Add user scatter gather I/O to SG_IO
Date: Mon, 13 Jun 2005 08:48:12 -0500
Message-ID: <1118670492.5079.1.camel@mulgrave>
References: <1118447969.5031.44.camel@mulgrave>
	 <20050613065529.GF1414@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:32897 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261562AbVFMNsa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 09:48:30 -0400
In-Reply-To: <20050613065529.GF1414@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-06-13 at 08:55 +0200, Jens Axboe wrote:
> Didn't you want to remove more than the comment here?

Well ... like I said, it was lightly tested ...

I figured if I could still get SG_IO to work at all, then I'd proved
that single element SG lists worked ...

> > +		/* try to reset the bus and the card to a sane state */
> > +		scsi_try_bus_reset(scmd);
> > +		scsi_try_host_reset(scmd);
> >  		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
> >  		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD)) {
> 
> Different patch?

Yes, contamination, sorry.

> Other than that I think it looks good, thanks. I'll get this added asap.

Great ... let me know when you have a tree ready and I'll move to base
the SCSI changes off it.

James


