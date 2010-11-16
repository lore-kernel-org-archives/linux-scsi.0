From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Unloading sym53c8xx driver causes ___free_dma_mem_cluster
	warnings
Date: Tue, 16 Nov 2010 12:27:19 -0700
Message-ID: <20101116192718.GC6178@parisc-linux.org>
References: <20101116191309.DD04C14E644@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48490 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0KPT1U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2010 14:27:20 -0500
Content-Disposition: inline
In-Reply-To: <20101116191309.DD04C14E644@gemini.denx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 08:13:09PM +0100, Wolfgang Denk wrote:
> Hi,
> 
> when unloading the sym53c8xx driver a number of kernel warning
> messages are printed:

Yes, this is well known (if you search the scsi archives, you'll find
several previous reports).  It's harmless -- the only place it could hurt
is on ARM, and I've never heard of anyone plugging a sym2 card into an
ARM machine.

The fix would be quite involved, and the driver really isn't worth fixing
-- the hardware tops out at 160 MB/s which is an order of magnitude
lower performance than the hardware I'm currently working on.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
