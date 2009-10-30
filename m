From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_debug: Thin provisioning support
Date: Thu, 29 Oct 2009 22:40:59 -0400
Message-ID: <yq1pr85txhg.fsf@sermon.lab.mkp.net>
References: <yq1d44o8piw.fsf@sermon.lab.mkp.net>
	<20091029072322.GA25926@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:49774 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbZJ3Cl7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 22:41:59 -0400
In-Reply-To: <20091029072322.GA25926@infradead.org> (Christoph Hellwig's
	message of "Thu, 29 Oct 2009 03:23:22 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> And a crash when using unmap_granularity=1 when using the
Christoph> discard-enable mkfs.xfs binary from xfsprogs-dev.git:

I was unable to reproduce.  I also tried with xfs_trim.  Both work fine.
I guess I'll try with your two latest patches in the mix next.

i386, x86_64, ppc?


Christoph> qemu1:~/xfsprogs-dev# ./mkfs/mkfs.xfs -f /dev/sdb [
Christoph> 53.562041] BUG: unable to handle kernel paging request at
Christoph> fcc80000 [ 53.563812] IP: [<c070fbb7>]
Christoph> unmap_region+0xc7/0x120
           ^^^^^^^^^^^^^^^^^

That's pretty odd.  It's way beyond the end of unmap_region here.

-- 
Martin K. Petersen	Oracle Linux Engineering
