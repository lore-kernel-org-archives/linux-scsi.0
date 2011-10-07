From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] qlogicpti: fix timeout
Date: Fri, 07 Oct 2011 11:13:23 -0400 (EDT)
Message-ID: <20111007.111323.497093696267353976.davem@davemloft.net>
References: <alpine.SOC.1.00.1110071050080.648@math.ut.ee>
	<alpine.SOC.1.00.1110071800120.29152@math.ut.ee>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:45708 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1JGPN2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2011 11:13:28 -0400
In-Reply-To: <alpine.SOC.1.00.1110071800120.29152@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mroos@linux.ee
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Fri, 7 Oct 2011 18:05:08 +0300 (EEST)

> qlogicpti times out for some tape library operations (like mtx 
> inventory). It seems SCSI command timeout is hardcoded into the driver. 
> Fix it by propagating the timeout from scsi request to the controller as 
> suggested by James Bottomley.
> 
> Tested on Sun Ultra 1 with Sun StorEdge L8 Autoloader.
> 
> Signed-off-by: Meelis Roos <mroos@linux.ee>

Acked-by: David S. Miller <davem@davemloft.net>
