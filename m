From: Matthew Wilcox <willy@debian.org>
Subject: Re: Megaraid - Can't boot vanilla kernel
Date: Thu, 26 Feb 2004 17:18:36 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040226171836.GR25779@parcelfarce.linux.theplanet.co.uk>
References: <00e501c3fbfe$e477fe80$6400a8c0@defiant>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:49595 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262884AbUBZRSk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2004 12:18:40 -0500
Content-Disposition: inline
In-Reply-To: <00e501c3fbfe$e477fe80$6400a8c0@defiant>
List-Id: linux-scsi@vger.kernel.org
To: Nicolas Ross <rossnick-lists@cybercat.ca>
Cc: linux-scsi@vger.kernel.org

On Wed, Feb 25, 2004 at 07:24:26PM -0500, Nicolas Ross wrote:
> I have a Dell Poweredge 400sc with a CERC IDE Raid card (megaraid driver).
> The system is installed with RedHat 7.3 and running with the latest kernel
> from RedHat with no trouble.
> 
> I need to compile a vanilla (from kernel.org) 2.4.24 kernel to build into it
> a specific driver. I can't get the new compiled kernel to boot. I get
> 
> Cannot open root device "sda1" or 08:01
> Pleas append a correct "root=" boot option
> Kernel panic: VFS: Unable to mount root fs on 08:01

You compiled megaraid as a module, but I bet you're not using an initrd.
You should probably just compile it into the kernel (ie Y instead of M)
rather than messing around with an initrd.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
