From: Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: Defect list size ?
Date: Wed, 16 Mar 2005 12:47:39 -0800
Message-ID: <20050316204739.GA4507@bougret.hpl.hp.com>
References: <20050316194709.GA4444@bougret.hpl.hp.com> <20050316195625.GA12283@lists.us.dell.com>
Reply-To: jt@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from palrel11.hp.com ([156.153.255.246]:43176 "EHLO palrel11.hp.com")
	by vger.kernel.org with ESMTP id S262788AbVCPUrk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 15:47:40 -0500
Content-Disposition: inline
In-Reply-To: <20050316195625.GA12283@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Mar 16, 2005 at 01:56:25PM -0600, Matt Domsch wrote:
> On Wed, Mar 16, 2005 at 11:47:09AM -0800, Jean Tourrilhes wrote:
> > 	Hi,
> > 
> > 	What is a reasonable defect list size for an almost new disk
> > (3 weeks - 146 GB).
> > 	scscinfo -d gives me :
> > --------------------------------------------
> > Data from Defect Lists
> > ----------------------
> > 3060 entries in manufacturer table.
> > ...
> > [truncated]
> > --------------------------------------------
> > 	Which is way more than my older and smaller disk. I'm
> > wondering if this is acceptable or if I have a bad disk.
> 
> 306184192 sectors (give or take a few) on that disk.
>      3060 sectors bad at low-level format time.
> 
> While it may feel like a large number, it really isn't for the size
> disk you've got.
> 
> Now, if the number of "Grown" defects starts increasing, then yes, be
> worried.
> 
> Thanks,
> Matt

	Thanks very much for the quick answer. Yes, as you can see,
I'm used to much smaller disk and looking at all options about my
crashes (see other e-mail).
	Sorry for the trouble.

	Jean

