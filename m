From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Subject: Re: increase SD_STATS ?
Date: Fri, 19 Aug 2005 12:20:13 +0200
Message-ID: <4305B25D.7060708@ext.bull.net>
References: <43059223.4020205@ext.bull.net> <20050819092711.GA28752@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:61419 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S932615AbVHSKUR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 06:20:17 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 5E0CD19D909
	for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2005 12:20:17 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 28054-07 for <linux-scsi@vger.kernel.org>;
 Fri, 19 Aug 2005 12:20:16 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 0DD6219D907
	for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2005 12:20:16 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by openx3.frec.bull.fr (Postfix) with ESMTP id 2A0CF2B0E6
	for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2005 12:20:13 +0200 (CEST)
In-Reply-To: <20050819092711.GA28752@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hello Christoph,

Thanks for your answer.

Yes, I investigate about my kernel source (2.6.12) and I find that patches based 
on a RHEL kernel sources have been applied. This explains the odd 2.4 sd.c.

Best regards.


Christoph Hellwig wrote:
> On Fri, Aug 19, 2005 at 10:02:43AM +0200, Frederic TEMPORELLI wrote:
> 
>>Hi,
>>
>>
>>Due to SD_STATS=256  (/drivers/scsi/sd.c)
>>there's a limit on the max /dev/sd devices.
>>
>>Now, we have a large FC fabric, with more than 3500 LUNs...
>>=> Of course, we have an Oops when an HBA is connected to the fabric
>>(still sd.c, BUG in function sd_iostats_bump when sd>SD_STATS)
>>
>>What (bad) side-effects can be expected if we increase SD_STATS (4096 
>>should be nice, may be 8192) ?
> 
> 
>>From you description it looks like you are using some odd 2.4.x vendor
> tree.  Just upgrade to latest 2.6 and these limitations will go away.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Frederic TEMPORELLI
