From: David Miller <davem@davemloft.net>
Subject: Re: qlogicpti driver hangs the machine
Date: Sun, 28 Sep 2008 13:43:36 -0700 (PDT)
Message-ID: <20080928.134336.26891578.davem@davemloft.net>
References: <20080924.014553.221132445.davem@davemloft.net>
	<48DA01A6.1010807@panasas.com>
	<Pine.SOC.4.64.0809241240440.5968@math.ut.ee>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59852
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbYI1Uns (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Sep 2008 16:43:48 -0400
In-Reply-To: <Pine.SOC.4.64.0809241240440.5968@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mroos@ut.ee
Cc: bharrosh@panasas.com, matthew@wil.cx, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, jens.axboe@oracle.com

From: Meelis Roos <mroos@ut.ee>
Date: Wed, 24 Sep 2008 12:51:09 +0300 (EEST)

> > Subject: [PATCH] fix fall out of sg-chaining patch
> > 
> > I've reviewed all patches since Matthew's, and I find one small
> > problem.
> > 
> > In the load_cmd() there is a compound loop where the first 4 sg's are
> > set then the rest are set into a memory structure in group of 7 sg's.
> > 
> > Well the second 7-group and on is a bug because sg pointer does not advance.
> > This is a fall out from Jens's patch.
> > 
> > I'm not sure if this is it but it should be fixed
> 
> This definitely helps,

Can we get this bug fix merged if it isn't already?

Thanks.
