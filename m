From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 01 Mar 2005 14:14:47 -0500
Message-ID: <1109704486.2878.23.camel@localhost.localdomain>
References: <OF00F39C19.AE2C12A8-ON88256FB7.00641755-88256FB7.0065149B@us.ibm.com>
	 <1109702227.6293.137.camel@laptopd505.fenrus.org>
	 <1109702911.2878.16.camel@localhost.localdomain>
	 <4224BC17.7000103@pobox.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from leviathan.ele.uri.edu ([131.128.51.64]:35003 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S261990AbVCATPE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 14:15:04 -0500
In-Reply-To: <4224BC17.7000103@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Bryan Henderson <hbryan@us.ibm.com>, Tomonori Fujita <fujita.tomonori@lab.ntt.co.jp>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2005-03-01 at 14:01, Jeff Garzik wrote:
> Ming Zhang wrote:
> > On Tue, 2005-03-01 at 13:37, Arjan van de Ven wrote:
> > 
> >>On Tue, 2005-03-01 at 10:24 -0800, Bryan Henderson wrote:
> >>
> >>>One thing that's implicit in your reasons for wanting to be in the kernel 
> >>>is that you've chosen to exploit the kernel's page cache.  As a user of 
> >>>the page cache, you have more control from inside the kernel than from 
> >>>user space.  The page cache was designed to be fundamentally invisible to 
> >>>user space.
> >>>
> >>>A pure user space implementation of an ISCSI target would use process 
> >>>virtual memory for a cache and manage it itself.  It would access the 
> >>>storage with direct I/O. 
> >>
> >>why would it use direct I/O ? Direct I/O would be really stupid for such
> >>a thing to use since that means there's no caching going on *at all*.
> >>
> > 
> > what Bryan suggest is a privately owned and managed user space cache. so
> > for that disk write should be real write-through.
> > 
> > it is hard to beat linux kernel cache performance though.
> 
> A privately managed user space cache uses Linux kernel cache.
what i mean is private cache algorithms. for example, windows request
are not page size aligned so some bitmap based cache algorithms might be
useful. 

> 
> As does mmap/sendfile...
> 
> 	Jeff
> 


