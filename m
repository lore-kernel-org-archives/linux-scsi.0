From: Meelis Roos <mroos@linux.ee>
Subject: Re: sparc ESP SCSI error handling BUG+hang
Date: Tue, 30 Jul 2013 12:58:44 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1307301257120.260@math.ut.ee>
References: <alpine.SOC.1.00.1304211357540.2145@math.ut.ee> <20130729.153223.2291945302397524459.davem@davemloft.net> <20130729.161532.1928549790091477295.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:40887 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758729Ab3G3J6t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jul 2013 05:58:49 -0400
In-Reply-To: <20130729.161532.1928549790091477295.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org

> > Therefore I think the fix is going to involve adding a member to
> > "struct esp_cmd_entry" called "->orig_tag[]" so that we can see what
> > the original tag[] values were at esp_alloc_lun_tag() time.
> 
> Please try this patch:

It works on 3 consecutive boots, thank you!

Tested-by: Meelis Roos <mroos@linux.ee>

-- 
Meelis Roos (mroos@linux.ee)
