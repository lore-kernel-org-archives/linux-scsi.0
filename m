From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bugme-new] [Bug 16058] New: [BUG] Cannot boot any kernel from
 2.6.27 on if a 256 byte sector SCSI disk is attached
Date: Thu, 27 May 2010 17:17:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1005271716390.3239-100000@iolanthe.rowland.org>
References: <4BFED978.4020902@compro.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:36093 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753571Ab0E0VSA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 17:18:00 -0400
In-Reply-To: <4BFED978.4020902@compro.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Hounschell <markh@compro.net>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, bugzilla-daemon@bugzilla.kernel.org

On Thu, 27 May 2010, Mark Hounschell wrote:

> >> As of 2.6.27 if any SCSI disk is attached that has been formatted with a 256
> >> byte sector size, the boot process hangs. 512, 768, and 1024 byte sector disks

> >> The does the same thing on a 2.6.34 kernel. Anything I can do to help, I'm
> >> available.

> Yes, I can. But first let me ask, since reverting this patch on at least
> 2.6.32 - 2.6.34 does not help, would it possibly be better if I did a
> little more work to find out where it stops working with the above patch
> reverted or not?

I'd do 2.6.27 first, since that's where the problem started.  Then move 
on to 2.6.34.  There may be two different problems.

Alan Stern

