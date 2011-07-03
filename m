From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sun, 3 Jul 2011 03:17:58 +0200
Message-ID: <20110703011758.GB15637@one.firstfloor.org>
References: <20110702181146.GM23059@one.firstfloor.org> <Pine.LNX.4.44L0.1107021544550.16190-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:55619 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab1GCBR7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jul 2011 21:17:59 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107021544550.16190-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <andi@firstfloor.org>, axboe@kernel.dk, James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Jones <davej@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, USB list <linux-usb@vger.kernel.org>

> Would you like to try this patch to see if it fixes the problem?  As I 
> said before, I'm not certain it's the best thing to do, but it worked 
> on my system.

I can try next week.

Is this patch likely to fix the RCU stall?

-Andi
