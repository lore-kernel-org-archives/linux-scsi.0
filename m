From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [usb-storage] Re: Make UAS work on HS for devices with and
 without command tagging support
Date: Fri, 16 Dec 2011 15:31:46 -0500
Message-ID: <20111216203146.GN14291@linux.intel.com>
References: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
 <20111214225331.GA5508@xanatos>
 <4EE9B375.4020606@linutronix.de>
 <20111215211201.GA6482@xanatos>
 <20111216144724.GC19563@linutronix.de>
 <20111216201236.GE19563@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16158 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932640Ab1LPUbs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 15:31:48 -0500
Content-Disposition: inline
In-Reply-To: <20111216201236.GE19563@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

On Fri, Dec 16, 2011 at 09:12:36PM +0100, Sebastian Andrzej Siewior wrote:
> * Sebastian Andrzej Siewior | 2011-12-16 15:47:24 [+0100]:
> 
> >>If you want to take a stab at redoing your patch #2 to use only one
> >>status URB for USB 2.0 devices, I would appreciate it.  Then I can build
> >>the abort/reset synchronization on top of it.
> >Okay.
> 
> Just once things started to become easy.... So while I tried to have
> only one status urb which I always re-submit (as Matthew/ You suggested)
> I run into the problem that I don't have struct scsi_device yet. So I
> just created a device with two luns to see if this struct happens always
> to be same. Ofcourse it is not. 

Can you not send one status URB per LUN (instead of one per command)?
