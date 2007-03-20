From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Kernel 2.6.20 does not work anymore with SCSI or SATA on old
 Opteron / Xeon servers
Date: Mon, 19 Mar 2007 23:27:32 -0800
Message-ID: <20070319232732.854d7120.akpm@linux-foundation.org>
References: <45FDA626.9000404@prie.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51302 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbXCTH1l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2007 03:27:41 -0400
In-Reply-To: <45FDA626.9000404@prie.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Priebe <stefan@prie.be>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, 18 Mar 2007 21:50:46 +0100 Stefan Priebe <stefan@prie.be> wrote:

> Hello!
> 
> We've a very strange Problem with Kernel 2.6.20.x
> 
> If i try to access a SCSI or SATA Disk (tested with Adaptec U320 
> ASC-29320, ICP Vortex 9024, Promise TX300) the whole server hangs - no 
> output - no error on the screen - but it hangs completely. But it does 
> not happen on all our systems affected are only old 604pin xeons and 
> socket 940 Opterons. Socket F Opteron or 771 Xeons does work fine.
> 
> I've also testet apci=off pci=routeirq but both does not help. The 
> systems work fine with 2.6.19.x and before.

Well that's a bit sad.

Could you please set up netconsole
(Documentation/networking/netconsole.txt) and add initcall_debug to the
kernel boot command line and then send us the full bootup logs?

(Even better: serial console with earlyprintk).

If that doesn't shed any light, we might have to ask you to perform a
git-bisect search to find the buggy commit, I'm afraid.
