From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] remove unused includes and misleading comments from
 scsi_lib.c
Date: Wed, 20 Nov 2002 13:25:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211201925.gAKJPTx03466@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id LAA26492
	for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2002 11:25:34 -0800
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Wed, 20 Nov 2002 11:10:16 PST." <20021120111016.A20388@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

patmans@us.ibm.com said:
> It is in hardirq.h, arch specific, 11 of the 20 hardirq.h files would
> need the change (they reference kernel_locked) to include smp_lock.h.

> 665 files include smp_lock.h 89  files include hardirq.h 32  files
> include both

> So, should I change the arch hardirq.h files to include smp_lock.h, or
> just add smp_lock.h to scsi_lib.c? 

That magnitude of change needs to go in through the header files project.  
I'll just apply the smp_lock.h in scsi_lib fix to the scsi tree for now.  They 
can always take it out again for the proper fix.

James


