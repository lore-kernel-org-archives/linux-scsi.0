From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: Wed, 29 Sep 2004 10:09:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929170957.GA5141@us.ibm.com>
References: <415ADD7D.6060105@adaptec.com> <Pine.LNX.4.44L0.0409291239250.1167-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:49608 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S268716AbUI2RKZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 13:10:25 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0409291239250.1167-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>, Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

Alan Stern [stern@rowland.harvard.edu] wrote:
> On Wed, 29 Sep 2004, Luben Tuikov wrote:
> 
> > > Next usb-storage called scsi_remove_host().  Apparently this caused some
> > > component of the CD driver to queue a command:
> 
> This sounds like a bug, by the way.  Commands shouldn't be queued because 
> of a call to scsi_remove_host!
> 

There was a reordering in the scsi_remove_host by me that may be causing
your problem. Ths change was to allow devices to receive there
SYNCRHONIZE_CACHE commands on rmmod.

You can see part of the thread here.

http://marc.theaimsgroup.com/?t=108701426000002&r=1&w=2


-andmike
--
Michael Anderson
andmike@us.ibm.com

