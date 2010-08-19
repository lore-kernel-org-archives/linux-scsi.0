From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Thu, 19 Aug 2010 12:22:45 +0200
Message-ID: <4C6D05F5.9000204@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100818094620.GA14707@lst.de> <4C6D0021.4040601@kernel.org> <20100819102023.GA6736@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:43356 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab0HSK0u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2010 06:26:50 -0400
In-Reply-To: <20100819102023.GA6736@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de

Hello,

On 08/19/2010 12:20 PM, Christoph Hellwig wrote:
> I said make_request based drivers, that is drivers taking bios.

Right.  Gees, it's confusing.

> These get bios directly from __generic_make_request and need to deal
> with REQ_FLUSH/FUA themselves.  We have quite a few more than just
> dm/md of this kind:
>
> arch/powerpc/sysdev/axonram.c
> drivers/block/aoe/aoeblk.c
> drivers/block/brd.c

I'll try to convert these three.

> drivers/block/drbd/drbd_main.c

I'd rather leave drbd to its maintainers.

> drivers/block/loop.c

Already converted.

> drivers/block/pktcdvd.c
> drivers/block/ps3vram.c
> drivers/block/umem.c
> drivers/s390/block/dcssblk.c
> drivers/s390/block/xpram.c
> drivers/staging/zram/zram_drv.c

Will work on these.

Thanks.

-- 
tejun
