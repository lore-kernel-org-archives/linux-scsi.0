From: Samuel Colin <Samuel.Colin3@wanadoo.fr>
Subject: Re: What is SCSI command 0xa0 ?
Date: Thu, 17 Feb 2005 16:59:40 +0100
Message-ID: <20050217165940.23cd9521@hebus>
References: <20050214230645.22eb3b3c@hebus>
	<Pine.LNX.4.44L0.0502161133350.6418-100000@ida.rowland.org>
Reply-To: samuel.colin3@wanadoo.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from smtp4.wanadoo.fr ([193.252.22.27]:9371 "EHLO smtp4.wanadoo.fr")
	by vger.kernel.org with ESMTP id S262277AbVBQP7k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 10:59:40 -0500
In-Reply-To: <Pine.LNX.4.44L0.0502161133350.6418-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

The Wed, 16 Feb 2005 11:42:18 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> Good.  The patch below ought to accomplish the same thing as that "echo" 
> command.  You can try patching your kernel and make sure that it really 
> works.  If it does, I'll submit the patch for official inclusion in the 
> kernel.
> 
I recompiled the kernel with the patch, and deactivated the debugging (to
avoid any possible slowing of the tests). After modprobing the needed
modules (ehci-hcd and usb-storage), I mounted the disks (no error, as
expected) and did the following :
- Copied about 12 Go of datas from lacie1 to lacieroot (at at least 20Mo/s,
so it didn't take long)
- Made an md5sum for all the copied files at the same time on lacie1 and
lacieroot. The resulting sums were exactly the same.
So if it doesn't look like a successful test, I don't know what does.

> I don't know why.  Do you want to turn on usb-storage verbose debugging in
> the 2.6.8 kernel, and run it on that other machine?
> [...]
> It's hard to say, since there are so many things being changed all the
> time.  But if the REPORT_LUNS command worked under 2.6.8 and failed under
> 2.6.11, it would be worthwhile to know why.
> 
OK, I will do and send the debug logs asap.

linux-usb-devel and linux-scsi (as they might be interested in the test
results for the 2.6.8 kernel) in Cc:

Regards,
Samuel Colin

