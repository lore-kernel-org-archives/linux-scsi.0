From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Defect list size ?
Date: Wed, 16 Mar 2005 13:56:25 -0600
Message-ID: <20050316195625.GA12283@lists.us.dell.com>
References: <20050316194709.GA4444@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:186 "EHLO
	ausc60pc101.us.dell.com") by vger.kernel.org with ESMTP
	id S262771AbVCPT40 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 14:56:26 -0500
Content-Disposition: inline
In-Reply-To: <20050316194709.GA4444@bougret.hpl.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jean Tourrilhes <jt@hpl.hp.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Mar 16, 2005 at 11:47:09AM -0800, Jean Tourrilhes wrote:
> 	Hi,
> 
> 	What is a reasonable defect list size for an almost new disk
> (3 weeks - 146 GB).
> 	scscinfo -d gives me :
> --------------------------------------------
> Data from Defect Lists
> ----------------------
> 3060 entries in manufacturer table.
> ...
> [truncated]
> --------------------------------------------
> 	Which is way more than my older and smaller disk. I'm
> wondering if this is acceptable or if I have a bad disk.

306184192 sectors (give or take a few) on that disk.
     3060 sectors bad at low-level format time.

While it may feel like a large number, it really isn't for the size
disk you've got.

Now, if the number of "Grown" defects starts increasing, then yes, be
worried.

Thanks,
Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
