From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: rootfs on sda & async scan?
Date: Sun, 17 Jun 2007 11:01:46 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0706171100370.4053@poirot.grange>
References: <Pine.LNX.4.60.0706170035450.3805@poirot.grange>
 <20070617022552.GM8154@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56106 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755785AbXFQJBq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Jun 2007 05:01:46 -0400
In-Reply-To: <20070617022552.GM8154@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Sat, 16 Jun 2007, Matthew Wilcox wrote:

> On Sun, Jun 17, 2007 at 12:42:44AM +0200, Guennadi Liakhovetski wrote:
> > sd* as long as the respective ldd is linked into the kernel. Now, this 
> > just didn't work for me under 2.6.22-rc3-... (scsi-misc-2.6) with 
> > sym53c8xx_2. I'd expected it would let scan run asynchronously, but wait 
> > as long as root on an sd* is requested. Do I understand it wrong or is 
> > this a bug somewhere. I also have 2 more ldd's compiled as modules.
> 
> Did you have
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=f2f027c6e9912840020be8b78f037d5c8ac665e0
> in your tree?  It's supposed to fix this bug.

No, it is still not in scsi-misc-2.6.

Thanks for the pointer
Guennadi
---
Guennadi Liakhovetski
