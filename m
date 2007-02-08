From: Andreas Moroder <andreas.moroder@sb-brixen.it>
Subject: Re: persistent scsi with udev
Date: Thu, 08 Feb 2007 16:47:10 +0100
Message-ID: <eqfgkl$tbl$1@sea.gmane.org>
References: <eqf3li$9s7$1@sea.gmane.org> <45CB3141.2030707@emulex.com> <45CB3CDA.9040704@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:37359 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161523AbXBHPrG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Feb 2007 10:47:06 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1HFBTz-0007H1-Vi
	for linux-scsi@vger.kernel.org; Thu, 08 Feb 2007 16:46:48 +0100
Received: from merlin2.provinz.bz.it ([62.101.0.30])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 08 Feb 2007 16:46:47 +0100
Received: from andreas.moroder by merlin2.provinz.bz.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 08 Feb 2007 16:46:47 +0100
In-Reply-To: <45CB3CDA.9040704@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Michael Reed schrieb:
> While you didn't explicitly mention which distro you're using, some already
> have udev in their initrd.  If this applies in your case, you should be able
> to change the root= parameter passed to the kernel to specify your root device
> via a persistent name.  For example:
> 
> 	root=/dev/disk/by-path/pci-0000:01:03.0-scsi-0:0:1:0p1
> 
> You can do the same in your /etc/fstab for the root device.
> 
> You can ALSO change the order in which modules are loaded via /etc/modprobe.conf,
> or /etc/sysconfig/kernel, or something similar for your distro, so that the driver
> for your root device is always loaded first.
> 
> I hope this helps.
> 
> Mike
> 
hello Mike,

we use SLES 10.
The direct path is THE solution.

Thanks
Andreas

