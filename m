From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 25 Mar 2008 12:09:10 -0600
Message-ID: <20080325180910.GF16721@parisc-linux.org>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <1206458278.3273.5.camel@localhost.localdomain> <87f94c370803251045h46cbdc0auc541302fbad4a3b9@mail.gmail.com> <20080325105228.26396685.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57268 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYCYSJ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2008 14:09:28 -0400
Content-Disposition: inline
In-Reply-To: <20080325105228.26396685.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Mark Lord <lkml@rtr.ca>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Mar 25, 2008 at 10:52:28AM -0700, Randy Dunlap wrote:
> > I'm not sure what the Linux Kernel support is for GPTs.
> 
> It's implemented.  Not sure about how well used/tested it is.

ia64 uses it exclusively ... at least on discs that you want to use from
EFI.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
