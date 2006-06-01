From: maximilian attems <maks@sternwelten.at>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Thu, 1 Jun 2006 15:21:43 +0200
Message-ID: <20060601132143.GH28353@baikonur.stro.at>
References: <20060511143352.GI12272@parisc-linux.org> <20060518172258.GL1604@parisc-linux.org> <20060529031915.GB23405@parisc-linux.org> <447AB2F5.2000700@s5r6.in-berlin.de> <20060529130515.GE23405@parisc-linux.org> <20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:1486 "EHLO baikonur.stro.at")
	by vger.kernel.org with ESMTP id S965112AbWFANVr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2006 09:21:47 -0400
Content-Disposition: inline
In-Reply-To: <447EE81D.2050906@ums.usu.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>, linux-hotplug-devel@lists.sourceforge.net, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

On Thu, Jun 01, 2006 at 07:14:05PM +0600, Alexander E. Patrakov wrote:
> Patrick Mansfield wrote:
> >>That's what scsi_complete_async_scans() is for.  If you have a built-in
> >>module, it will wait for the async scans to finish before we get as far
> >>as trying to mount root.  It does change observable behaviour in that
> >>sys_module_init() will return before scans are complete.
> 
> What are the expected interactions of this code with early userspace aka 
> "kinit" that comes with (soon to be merged) klibc? Does this 
> scsi_complete_async_scans() function get called at all if such "default" 
> initramfs with kinit is used?
> 
> The problem is that if it doesn't, kinit will not wait.

unless you build an hardcoded initramfs for an specific box,
you want anyway an coldplugging utility on board.

udev can be compiled with klibc, put both inside your initramfs.

-- 
maks
