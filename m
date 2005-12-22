From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new version of iscsi
 target?
Date: Thu, 22 Dec 2005 13:38:46 +0300
Message-ID: <43AA8236.0@vlnb.net>
References: <43987F75.2000301@vlnb.net>	<4398850D.8070102@cs.wisc.edu>	<1134071290.3259.31.camel@mulgrave> <20051222085316J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03.infobox.ru ([195.208.235.28]:63377 "EHLO
	relay03.infobox.ru") by vger.kernel.org with ESMTP id S1750861AbVLVKjH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2005 05:39:07 -0500
In-Reply-To: <20051222085316J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt-devel@lists.berlios.de, WRWHITEHEAD@novell.com, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, hch@infradead.org

FUJITA,

It would be helpful if you also gather CPU utilization statistics during 
the tests (user/kernel/idle/iowait time + context switches/sec rate).

Vlad

FUJITA Tomonori wrote:
> I did some initial performance tests with both tgt versions and IET
> (as you know, another iSCSI software implementation runs in kernel
> space). All implementations run with write back policy so probably,
> there should be little real disk I/O effect. I started disktest
> benchmark software with cold cache state. The machine has 4 GB memory,
> 1.5K SCSI disk, 4 CPUs (x86_64).
> 
> (disktest -PT -T10 -h1 -K8 -B8192 -ID /dev/sdc -w)
> 
> o IET
> | 2005/12/21-18:05:15 | STAT  | 7259 | v1.2.8 | /dev/sdc | Total write throughput: 48195993.6B/s (45.96MB/s), IOPS 5883.3/s.
> 
> o tgt (I/O in kernel space)
> | 2005/12/21-18:03:23 | STAT  | 7013 | v1.2.8 | /dev/sdc | Total write throughput: 45829324.8B/s (43.71MB/s), IOPS 5594.4/s.
> 
> o mmap tgt
> | 2005/12/21-18:22:28 | STAT  | 7990 | v1.2.8 | /dev/sdc | Total write throughput: 25373900.8B/s (24.20MB/s), IOPS 3097.4/s.

