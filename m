From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 01 Mar 2005 16:15:15 -0500
Message-ID: <1109711714.2878.72.camel@localhost.localdomain>
References: <OF961A122F.772A6491-ON88256FB7.0072D359-88256FB7.0073C3F8@us.ibm.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from leviathan.ele.uri.edu ([131.128.51.64]:46986 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S262088AbVCAVPe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 16:15:34 -0500
In-Reply-To: <OF961A122F.772A6491-ON88256FB7.0072D359-88256FB7.0073C3F8@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Tomonori Fujita <fujita.tomonori@lab.ntt.co.jp>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2005-03-01 at 16:04, Bryan Henderson wrote:
> >it is hard to beat linux kernel [page] cache performance though.
> 
> It's quite easy to beat it for particular applications.  You can use 
> special knowledge about the workload to drop pages that won't be accessed 
> soon in favor of pages that will, not clean a page that's just going to 
> get discarded or overwritten soon, allocate less space to less important 
> data, and on and on.
u are talking about application aware caching/prefetching stuff. but i
prefer to modifying kernel page cache a little bit while make use of
most of the code there.


> 
> And that's pretty much the whole argument for direct I/O.  Sometimes the 
> code above the filesystem layer is better at caching.
> 
> Of course, in this thread we're not talking about beating the page cache 
> -- we're just talking about matching it, while reaping other benefits of 
> user space code vs kernel code.
> 
yes, we went too far.

> --
> Bryan Henderson                          IBM Almaden Research Center
> San Jose CA                              Filesystems

