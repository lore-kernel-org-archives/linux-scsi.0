From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Wed, 02 Mar 2005 14:34:00 -0500
Message-ID: <1109792040.2878.102.camel@localhost.localdomain>
References: <OF28B4EEEA.0271C53B-ON85256FB8.0064150B-88256FB8.00646550@us.ibm.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from leviathan.ele.uri.edu ([131.128.51.64]:13719 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S262273AbVCBTe0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2005 14:34:26 -0500
In-Reply-To: <OF28B4EEEA.0271C53B-ON85256FB8.0064150B-88256FB8.00646550@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Tomonori Fujita <fujita.tomonori@lab.ntt.co.jp>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2005-03-02 at 13:20, Bryan Henderson wrote:
> >u are talking about application aware caching/prefetching stuff. but i
> >prefer to modifying kernel page cache a little bit while make use of
> >most of the code there.
> 
> That's a powerful argument for using the page cache, and further, for 
> using it from within the kernel.  I once started a project to port a 
> particular filesystem driver from the kernel to user space.  It was to be 
> used in a Linux system whose sole purpose was to export one filesystem via 
> NFS.  I was looking for engineering ease.  Everything about porting the 
> driver to user space was almost trivial except for duplicating the page 
> cache, and that was enough work to call into question the whole strategy 
> (I never went far enough to actually make a decision).
> 
i tried several time before on implementing own cache structures in user
space/ kernel space. every time i think i can do it better than before.
but frankly, there are always corner cases that make it performs poor.


> But I'm sure there are cases where the tradeoff works.
yes. i am sure about this as well.

> 
> --
> Bryan Henderson                               San Jose California
> IBM Almaden Research Center                   Filesystems

