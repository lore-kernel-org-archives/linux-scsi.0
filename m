From: Avi Kivity <avi@argo.co.il>
Subject: Re: [PATCH] drivers/scsi/sd.c: fix uninitialized variable in handling
 medium errors
Date: Thu, 27 Apr 2006 12:37:24 +0300
Message-ID: <445090D4.2070203@argo.co.il>
References: <200604261627.29419.lkml@rtr.ca>	<1146092161.12914.3.camel@mulgrave.il.steeleye.com>	<20060426161444.423a8296.akpm@osdl.org>	<44500033.3010605@rtr.ca> <20060426163536.6f7bff77.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.argo.co.il ([194.90.79.130]:46598 "EHLO
	argo2k.argo.co.il") by vger.kernel.org with ESMTP id S965032AbWD0Jh2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Apr 2006 05:37:28 -0400
In-Reply-To: <20060426163536.6f7bff77.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Mark Lord <lkml@rtr.ca>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Andrew Morton wrote:
> block, I suspect.  My DVD trauma was IDE-induced.  Jens is mulling the
> problem - I'd suggest you coordinate with him.
>
> It would be a good thing to fix.
>
> It's moderately hard to test, though.  Easy enough for DVDs and CDs, but
> it's harder to take a marker pen to a hard drive.
>   
If it's in the block layer, perhaps using a device mapper error target 
can help in testing. One could write a table to map an entire partition 
to a logical volume, then replace it with a table that maps a few 
sectors to the error target.

-- 
error compiling committee.c: too many arguments to function

