From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Block timeouts seem not to be working
Date: Thu, 11 Sep 2008 20:35:09 +0200
Message-ID: <20080911183509.GX20055@kernel.dk>
References: <1221145521.3330.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:58094 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756625AbYIKSfS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2008 14:35:18 -0400
Content-Disposition: inline
In-Reply-To: <1221145521.3330.2.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Sep 11 2008, James Bottomley wrote:
> I just noticed this with a rather finickey SAS system I have.  It's got
> a SATA DVD attached over an expander.  Periodically the DVD just hangs
> up, so we wait for the timeout and then send a phy reset which clears
> it.
> 
> What I'm seeing with the new block timer code is that the timer never
> expires.  I can dig some more into this, but if you wanted to test it as
> well, the timer code is easy to excite.  Just throw away one command in
> every 128 or so in the queuecommand routine of your favourite HBA
> driver.

James, I've seen a few oddities as well, I'll be beating on it tomorrow
again to shake out the last bug(s).

-- 
Jens Axboe

