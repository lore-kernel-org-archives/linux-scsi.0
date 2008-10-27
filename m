From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Mon, 27 Oct 2008 11:38:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0810271134530.15462-100000@iolanthe.rowland.org>
References: <20081027151818.GA4044@bit.office.eurotux.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48078 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750936AbYJ0PiP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2008 11:38:15 -0400
In-Reply-To: <20081027151818.GA4044@bit.office.eurotux.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luciano Rocha <luciano@eurotux.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-Kernel <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 27 Oct 2008, Luciano Rocha wrote:

> Hm, where in the code can I change it to return less that what it thinks
> is the last sector?

I can write a patch to do that for you.  However I'm more interested in 
solving the "infinite-retry" problem first.

I did write some patches which might help.  They weren't meant as bug 
fixes exactly, more as infrastructure cleanup.  But you ought to try 
them out, because they do affect the logic in this area.

The patches are here:

	http://marc.info/?l=linux-scsi&m=122443015406309&w=2

They are based on 2.6.27, not 2.6.28-rc.

Alan Stern

