From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/5] scsi: bnx2i: convert to workqueue
Date: Thu, 29 Jun 2017 15:57:56 +0200
Message-ID: <20170629135756.GP3808@linux-x5ow.site>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
 <20170410171254.30367-2-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48015 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753158AbdF2N56 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Jun 2017 09:57:58 -0400
Content-Disposition: inline
In-Reply-To: <20170410171254.30367-2-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, rt@linutronix.de, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>

So here we are again,
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>

FCoE will follow as soon as my setup can speak FCoE again.
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
