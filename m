From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: rootfs on sda & async scan?
Date: Sat, 16 Jun 2007 20:25:52 -0600
Message-ID: <20070617022552.GM8154@parisc-linux.org>
References: <Pine.LNX.4.60.0706170035450.3805@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54115 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbXFQCZy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Jun 2007 22:25:54 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0706170035450.3805@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Sun, Jun 17, 2007 at 12:42:44AM +0200, Guennadi Liakhovetski wrote:
> sd* as long as the respective ldd is linked into the kernel. Now, this 
> just didn't work for me under 2.6.22-rc3-... (scsi-misc-2.6) with 
> sym53c8xx_2. I'd expected it would let scan run asynchronously, but wait 
> as long as root on an sd* is requested. Do I understand it wrong or is 
> this a bug somewhere. I also have 2 more ldd's compiled as modules.

Did you have
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=f2f027c6e9912840020be8b78f037d5c8ac665e0
in your tree?  It's supposed to fix this bug.
