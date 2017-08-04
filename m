From: Meelis Roos <mroos@linux.ee>
Subject: Re: [PATCH] hpsa: disable volume status check for older controller
Date: Fri, 4 Aug 2017 22:58:32 +0300 (EEST)
Message-ID: <alpine.LRH.2.20.1708042258110.29380@math.ut.ee>
References: <1501686356-56888-1-git-send-email-hare@suse.de> <alpine.LRH.2.20.1708041923430.29380@math.ut.ee> <5be60e11-a3e7-14d1-0a67-db4fe909f004@suse.de> <823f4619-2596-8720-a10e-ecb056eaaf32@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:50743 "EHLO smtp2.it.da.ut.ee"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751318AbdHDT6g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Aug 2017 15:58:36 -0400
In-Reply-To: <823f4619-2596-8720-a10e-ecb056eaaf32@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

> You should be able to suppress the "can't get device id' messages with:

Yes, these messages are gone and it still works.

-- 
Meelis Roos (mroos@linux.ee)
