From: Oliver Neukum <oneukum@suse.de>
Subject: Re: READ_CAPACITY_16 vs. READ_CAPACITY_10
Date: Wed, 11 Sep 2013 17:05:47 +0200
Message-ID: <1378911947.28160.18.camel@linux-fkkt.site>
References: <Pine.LNX.4.44L0.1309111010500.1352-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab3IKPFs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Sep 2013 11:05:48 -0400
In-Reply-To: <Pine.LNX.4.44L0.1309111010500.1352-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: hare@suse.de, linux-scsi@vger.kernel.org

On Wed, 2013-09-11 at 10:14 -0400, Alan Stern wrote:

> There are three possibilities: nothing, your proposed patch, and a new

Nothing is feasible only if Windows uses READ_CAPACITY_10.

> quirk flag.  The flag is safest, but also the hardest to maintain.

Again the same answer.

> > I think we can be sure that no drive enclosure will crash
> > with READ_CAPACITY_16.
> 
> I wouldn't count on it, but I don't know of any examples.
> 
> > I am not sure about card readers.
> 
> Or flash drives.
> 
> > Does anybody know what Windows does?
> 
> Not me.  It probably varies with different versions of Windows.

I'll try to get a Windows machine for a trace.
Can you suggest a tracer for Win7?

	Regards
		Oliver



