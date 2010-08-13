From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH 0/8] rados block device and ceph refactor
Date: Fri, 13 Aug 2010 16:11:55 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1008131609270.5383@cobra.newdream.net>
References: <1281721240-26130-1-git-send-email-sage@newdream.net>
 <20100813153706.ee61c94e.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:54578 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab0HMXLk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Aug 2010 19:11:40 -0400
In-Reply-To: <20100813153706.ee61c94e.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org, hch@lst.de, akpm@linux-foundation.org, yehuda@hq.newdream.net

On Fri, 13 Aug 2010, Randy Dunlap wrote:
> On Fri, 13 Aug 2010 10:40:32 -0700 Sage Weil wrote:
> 
> > Hi,
> > 
> > The rados block device (rbd) implements a network block device backed by 
> > the Ceph distributed object store (think nbd/iSCSI, but distributed and 
> > fault tolerant).  At the suggestion of Christoph and James, this version 
> > of the patchset factors out the common Ceph bits (the network protocol, 
> > cluster membership, and object storage parts) into a libceph module 
> > (currently in net/ceph/ and include/linux/ceph/) that is shared by the 
> > file system component (fs/ceph) and rbd (drivers/block/rbd.c). The first 
> > few patches lay some groundwork, #7 moves does the ceph -> libceph+ceph 
> > split, and #8 adds the block device driver.
> 
> Hi,
> Did patch #7 make it to any mailing lists?
> I didn't receive it.

Sorry, I think vger ate it (it's 850KB).  You can see it here:

http://git.kernel.org/?p=linux/kernel/git/sage/ceph-client.git;a=commit;h=a6da68196474aabcdcc2f5dab64c0b55ca5090b7

sage

