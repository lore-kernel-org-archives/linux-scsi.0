From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
Date: Sat, 19 Apr 2008 17:14:47 -0600
Message-ID: <20080419231446.GR20637@parisc-linux.org>
References: <1208540517.3063.18.camel@localhost.localdomain> <20080419151934.GA17089@elte.hu> <1208620484.3280.23.camel@localhost.localdomain> <20080419170530.GD1595@cs181133002.pp.htv.fi> <1208626496.3280.40.camel@localhost.localdomain> <alpine.LFD.1.10.0804191305360.2779@woody.linux-foundation.org> <1208644076.3280.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54550 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbYDSXP1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Apr 2008 19:15:27 -0400
Content-Disposition: inline
In-Reply-To: <1208644076.3280.54.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>

On Sat, Apr 19, 2008 at 05:27:56PM -0500, James Bottomley wrote:
> > Not true. That's why we have initrd and ramdisks etc.
> 
> They don't currently seem to work for compiled in drivers ... we have
> the same issue with drivers that actually need firmware (like aic94xx or
> qla2xxx): no-one seems to have figured out how to provide it for them;
> it seems the device is already initialised and has failed to find its
> firmware before the initrd/initramfs is running.

WorksForMe ... or it did a few months ago.  I can re-test it with a
modern kernel ... wonder which machine I had that needed it ...

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
