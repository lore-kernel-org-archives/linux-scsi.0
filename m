From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI Driver Regression and Missing Code Block?
Date: Tue, 21 Apr 2009 20:09:28 -0600
Message-ID: <20090422020928.GD1926@parisc-linux.org>
References: <30274704.7281240360796458.JavaMail.root@mail.paragon.co.nz> <5313655.7301240361406269.JavaMail.root@mail.paragon.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39851 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZDVCJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 22:09:30 -0400
Content-Disposition: inline
In-Reply-To: <5313655.7301240361406269.JavaMail.root@mail.paragon.co.nz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dominic Driver <dominic.driver@paragon.co.nz>
Cc: linux-scsi@vger.kernel.org

On Wed, Apr 22, 2009 at 12:50:06PM +1200, Dominic Driver wrote:
> Hi Guys,
> 
> I had an interesting experience with my SATA DVD-RW Drives following a Kernel Upgrade from:
> 
> 2.6.27.19-170.2.35.fc10.i686
> to 
> 2.6.28.6 (Vanilla)

One of the problems with trying to diagnose the problem is that you're
going from a distro kernel to a vanilla kernel.  So it's not necessarily
something we've taken out -- it could be something they've put in and
we don't know about.

So it'd be really nice to see if 2.6.27 vanilla behaves like 2.6.28
vanilla or like 2.6.27-fc.  You might also want to try 2.6.29 as Fedora
do backport patches from later kernels.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
