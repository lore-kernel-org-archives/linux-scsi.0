From: Joe <joecool1029@gmail.com>
Subject: Re: Empty partition nodes not created (was device node issues with recent mm's and udev)
Date: Tue, 3 May 2005 23:49:55 -0400
Message-ID: <d4757e600505032049716c811b@mail.gmail.com>
References: <3ZVNP-5cq-7@gated-at.bofh.it>
	 <E1DTAgo-0002uD-F0@be1.7eggert.dyndns.org>
Reply-To: Joe <joecool1029@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.207]:60260 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261999AbVEDDt5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 May 2005 23:49:57 -0400
Received: by rproxy.gmail.com with SMTP id a41so90780rng
        for <linux-scsi@vger.kernel.org>; Tue, 03 May 2005 20:49:55 -0700 (PDT)
In-Reply-To: <E1DTAgo-0002uD-F0@be1.7eggert.dyndns.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 7eggert@gmx.de
Cc: linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>

On 5/3/05, Bodo Eggert <harvested.in.lkml@posting.7eggert.dyndns.org>
<7eggert@gmx.de> wrote:
> Joe <joecool1029@gmail.com> wrote:
> 
> > Here is the partition table from fdisk, fdisk does run fine.. its just
> > the fact this node is not created that threw me off before.
> >
> >    Device Boot      Start         End      Blocks   Id  System
> > /dev/sdb1   *           1           2       16033+   0  Empty
> > /dev/sdb2   *           6        2431    19486845    b  W95 FAT32
> > /dev/sdb3               3           5       24097+  83  Linux
> >
> > Notice, /dev/sdb1 is a Empty partition... in /dev I only have sdb,
> > sdb2, and sdb3.  No sdb1.  Any help would be appreciated.
> 
> Some vendors depend on empty partitions not showing up. That's why this
> patch was introduced.

It would be interesting to see just how important it is to hide this. 
 
> BTW: Is there a special reason you why choose "empty"?
> Is this partition showing up in other systems at all?

Actually, yes there is.. its a firmware partition that would normally
not be mounted, but in order to dd new firmware versions to it, I
depended on the node... which has ceased to exist.

I would like to see an easier workaround then just ignoring it like
that, but if its really needed....

Anyways, thanks everyone for the info, its much appreciated.

Joe
