From: Andrew Morton <akpm@digeo.com>
Subject: aix7xxx in 2.5.53
Date: Thu, 26 Dec 2002 01:17:24 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E0AC924.CEAD8965@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id BAA29572
	for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2002 01:17:26 -0800 (PST)
Received: from digeo-e2k04.digeo.com ([192.168.2.24])
 by digeo-nav01.digeo.com (NAVGW 2.5.2.12) with SMTP id M2002122601194221005
 for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2002 01:19:42 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


It is bouncing.  The machine has 7G of memory, was booted
with mem=4G.  The kernel was compiled with CONFIG_HIGHMEM4G.


c01304e8 115      0.0992971   buffered_rmqueue
c0146fc4 115      0.0992971   __find_get_block
c01602e4 126      0.108795    mpage_writepages
c012d5d4 147      0.126928    unlock_page
c0135554 151      0.130381    shrink_cache
c01892e8 170      0.146787    ext2_get_block
c0136c7c 173      0.149377    set_page_address
c0111930 184      0.158875    mark_offset_tsc
c0136be0 212      0.183052    page_address
c01d8418 2971     2.56532     __copy_from_user
c01369a4 3790     3.27249     __blk_queue_bounce
c01089f8 104325   90.0798     poll_idle
