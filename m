From: Meelis Roos <mroos@linux.ee>
Subject: Re: Fw: 2.6.14: aic7xxx broken with blktool
Date: Sat, 29 Oct 2005 13:17:03 +0300 (EEST)
Message-ID: <Pine.SOC.4.61.0510291310160.19371@math.ut.ee>
References: <20051028040227.37dfef86.akpm@osdl.org> <1130512908.3328.8.camel@mulgrave>
 <Pine.SOC.4.61.0510282124200.16664@math.ut.ee> <4362C5D1.80308@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from math.ut.ee ([193.40.36.2]:22914 "EHLO math.ut.ee")
	by vger.kernel.org with ESMTP id S1750831AbVJ2KR3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Oct 2005 06:17:29 -0400
In-Reply-To: <4362C5D1.80308@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

>> But blktool outputs memory fragments that seems to come from other
>> processes. I saw string "bash", "lled with unallocated bl" and other
>> strings that do not appear in blktools image. Without further
>> investigation it seems that in case of the error, soma data ise leaked
>> from kernel to the buggy program in userspace (blktool in this case).

Meanwhile I have identified that "lled ..." message is contained in 
glibc. Don't know about "bash" but it might have come from environment 
or other places since it's my login shell. So there need not be a kernel 
leak.

-- 
Meelis Roos (mroos@linux.ee)
