From: Pat LaVarre <p.lavarre@ieee.org>
Subject: fwd: 2.4.27rc2, DVD-RW support broke DVD-RAM writes
Date: Sun, 1 Aug 2004 08:17:04 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <76A380F2-E3C5-11D8-B01E-00039398BB5E@ieee.org>
References: <20040730153657.GB2748@logos.cnet> <20040731163334.GH23697@suse.
	de>
Mime-Version: 1.0 (Apple Message framework v618)
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:42730 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265978AbUHAOQo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Aug 2004 10:16:44 -0400
Received: from royntex01.iomegacorp.com (franklin [10.1.1.83])
	by email.iomega.com (Postfix) with ESMTP id DFD2B3F56
	for <linux-scsi@vger.kernel.org>; Sun,  1 Aug 2004 08:16:41 -0600 (MDT)
In-Reply-To: <20040731163334.GH23697@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>> With 2.4.27rc2 (and I assume anything later than pre5 - that's when
>> DVD-RW got added) DVD-RAMs have become read-only. Opening a DVD-RAM 
>> for
>> writing results in "EROFS (Read-only file system)" (reported by
>> 'strace'.
...
>  let Pat fix it. Pat?

I'll work first to duplicate this result, then try to fix it, maybe by 
deleting all set_disk_ro.

I'll look for code that ends up rewriting both DVD-RAM and Iomega REV 
discs.

> Also, any chance we get proper 'DVD-RAM is write-protected' support in
> 2.4.x ? It'd be really nice if write()/open(O_WRONLY) would fail in
> those cases.

I'll try Iomega REV discs with the MMC PWP switch flipped on and off.

 > ...

Please redirect me if need be.

Pat LaVarre
http://linux-pel.blog-city.com/read/754579.htm

