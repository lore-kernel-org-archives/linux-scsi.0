From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: [BUG 2.6.17-git] kmem_cache_create: duplicate cache scsi_cmd_cache
Date: Fri, 12 May 2006 22:21:38 +0200
Message-ID: <20060512202137.GC29077@harddisk-recovery.com>
References: <20060511151456.GD3755@harddisk-recovery.com> <15ddcffd0605112153q57f139a1k7068e204a3eeaf1f@mail.gmail.com> <20060512171632.GA29077@harddisk-recovery.com> <Pine.LNX.4.64.0605121024310.3866@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.126.206.180]:17292 "HELO abra2.bitwizard.nl")
	by vger.kernel.org with SMTP id S932218AbWELUVj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 16:21:39 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0605121024310.3866@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Or Gerlitz <or.gerlitz@gmail.com>, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, axboe@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, May 12, 2006 at 10:36:57AM -0700, Linus Torvalds wrote:
> It sounds like you used some other test-case than the trivial module above 
> to test bisection?

Yes, my test case is in here:

  http://marc.theaimsgroup.com/?l=linux-scsi&m=114736053211943&w=2

> So when you say "I tracked _it_ down with git bisect" (my emphasis), it 
> sounds like "it" was really something else than the trivial stand-alone 
> module. Or are you saying that the trivial stand-alone module _also_ got 
> fixed?

Sorry for being unclear. "it" is the bug report I send to linux-scsi
(see url above).



Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
