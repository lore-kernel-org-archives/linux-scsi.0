From: Erling Nygaard <nygaard@sistina.com>
Subject: Re: Bad fibre channel performance: need howto
Date: Fri, 21 Nov 2003 14:05:20 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031121200520.GK1418@sistina.com>
References: <1069443458.7047.35.camel@cala>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fry.sistina.com ([208.210.149.34]:63373 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S264430AbTKUUFJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 15:05:09 -0500
Received: from localhost.localdomain (plutonium [127.0.0.1])
	by localhost.localdomain (8.12.5/8.12.5) with ESMTP id hALK5KMt007671
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2003 14:05:20 -0600
Received: (from nygaard@localhost)
	by localhost.localdomain (8.12.5/8.12.5/Submit) id hALK5KuA007669
	for linux-scsi@vger.kernel.org; Fri, 21 Nov 2003 14:05:20 -0600
Content-Disposition: inline
In-Reply-To: <1069443458.7047.35.camel@cala>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Mario

I am/was the author of the FibreChannel HowTo. 

That howto slowly got outdated (Interesting how that happens when one does 
not have the same amount of spare time anymore...) and we eventually decided 
to take it off the Sistina website.

Not sure if the howto would have helped you in diagnosing this problem 
anyway ;)

Erling




On Fri, Nov 21, 2003 at 08:37:38PM +0100, Mario Giammarco wrote:
> Hello,
> I asked a similar question last week.
> I discovered that my hard disk which can do 60mb/sec sequential read,
> under linux/lsilogic40909 fibre hba gives only 30mb/sec, 45 if I tweak a
> lot readahead (why  I need to?).
> 
> I have searched a lot in internet and it seems that:
> 
> 1) fibrechannel howto was in sistina home page but now disappeared
> 2) fibrechannel specific mailing list for linux disappeared (archives
> to)
> 
> Where can I search for help? 
> Here it not seems appropriate to me. 
> 
> I have to find my bottleneck, please help with sending me docs.
> 
> -- 
> Mario Giammarco
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Erling Nygaard (nygaard@sistina.com)

Key fingerprint:
CA00 CF4E 9438 E348 E503  7ECF 9D94 D993 982A BDE0
