From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: [Iscsitarget-devel] Re: [ANNOUNCE] iSCSI enterprise target
	software
Date: Tue, 01 Mar 2005 14:29:25 -0500
Message-ID: <1109705365.2878.25.camel@localhost.localdomain>
References: <20050301190140.97212.qmail@web30006.mail.mud.yahoo.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from leviathan.ele.uri.edu ([131.128.51.64]:14277 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S262006AbVCATaE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 14:30:04 -0500
In-Reply-To: <20050301190140.97212.qmail@web30006.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Aggarwal <vaggarwal2002@yahoo.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, Tomonori Fujita <fujita.tomonori@lab.ntt.co.jp>, arjan@infradead.org, iet-dev <iscsitarget-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2005-03-01 at 14:01, Vikas Aggarwal wrote:
> And If  future IET be visioned as an Enterprise Class Array(Multiple
> Host-Side Adapters ie., FAs + Multiple Device Side Adapters ie., DAs),
> should better be in direct control of all the system-resources without
> being pushed out the kernel.
> 
of course this is the reason why we use that name.

ming

> Bryan Henderson <hbryan@us.ibm.com> wrote:
>         One thing that's implicit in your reasons for wanting to be in
>         the kernel 
>         is that you've chosen to exploit the kernel's page cache. As a
>         user of 
>         the page cache, you have more control from inside the kernel
>         than from 
>         user space. The page cache was designed to be fundamentally
>         invisible to 
>         user space.
>         
>         A pure user space implementation of an ISCSI target would use
>         process 
>         virtual memory for a cache and manage it itself. It would
>         access the 
>         storage with direct I/O. It looks to me like this is aimed at
>         a 
>         single-application Linux system (the whole system is just an
>         ISCSI 
>         target), which means there's not much need for a kernel to
>         manage shared 
>         resources.
>         
>         --
>         Bryan Henderson IBM Almaden Research Center
>         San Jose CA Filesystems
>         
>         
>         -------------------------------------------------------
>         SF email is sponsored by - The IT Pro duct Guide
>         Read honest & candid reviews on hundreds of IT Products from
>         real users.
>         Discover which products truly live up to the hype. Start
>         reading now.
>         http://ads.osdn.com/?ad_id=6595&alloc_id=14396&op=click
>         _______________________________________________
>         Iscsitarget-devel mailing list
>         Iscsitarget-devel@lists.sourceforge.net
>         https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel
> 
> ______________________________________________________________________
> Do you Yahoo!?
> Read only the mail you want - Yahoo! Mail SpamGuard.

