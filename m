From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 0/8] rados block device and ceph refactor
Date: Fri, 13 Aug 2010 15:37:06 -0700
Message-ID: <20100813153706.ee61c94e.rdunlap@xenotime.net>
References: <1281721240-26130-1-git-send-email-sage@newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:43813 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755674Ab0HMWhH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Aug 2010 18:37:07 -0400
Received: from chimera.site ([173.50.240.230]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 13 Aug 2010 15:37:06 -0700
In-Reply-To: <1281721240-26130-1-git-send-email-sage@newdream.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org, hch@lst.de, akpm@linux-foundation.org, yehuda@hq.newdream.net

On Fri, 13 Aug 2010 10:40:32 -0700 Sage Weil wrote:

> Hi,
> 
> The rados block device (rbd) implements a network block device backed by 
> the Ceph distributed object store (think nbd/iSCSI, but distributed and 
> fault tolerant).  At the suggestion of Christoph and James, this version 
> of the patchset factors out the common Ceph bits (the network protocol, 
> cluster membership, and object storage parts) into a libceph module 
> (currently in net/ceph/ and include/linux/ceph/) that is shared by the 
> file system component (fs/ceph) and rbd (drivers/block/rbd.c). The first 
> few patches lay some groundwork, #7 moves does the ceph -> libceph+ceph 
> split, and #8 adds the block device driver.

Hi,
Did patch #7 make it to any mailing lists?
I didn't receive it.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
