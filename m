From: Meelis Roos <mroos@ut.ee>
Subject: Re: Fw: 2.6.14: aic7xxx broken with blktool
Date: Fri, 28 Oct 2005 21:52:11 +0300 (EEST)
Message-ID: <Pine.SOC.4.61.0510282124200.16664@math.ut.ee>
References: <20051028040227.37dfef86.akpm@osdl.org> <1130512908.3328.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from math.ut.ee ([193.40.36.2]:37351 "EHLO math.ut.ee")
	by vger.kernel.org with ESMTP id S1750784AbVJ1SwZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 14:52:25 -0400
In-Reply-To: <1130512908.3328.8.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

>> It outputs random data from memory as a response to the scsi command,
>> different recent strings different times.
>
> This is a bug in blktool, so please refile appropriately.

Yes, I see. blktools seems to buggy, yes.

But blktool outputs memory fragments that seems to come from other 
processes. I saw string "bash", "lled with unallocated bl" and other 
strings that do not appear in blktools image. Without further 
investigation it seems that in case of the error, soma data ise leaked 
from kernel to the buggy program in userspace (blktool in this case).

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
