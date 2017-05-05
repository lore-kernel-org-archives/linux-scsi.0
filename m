From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] scsi: bnx2fc: convert per-CPU thread to workqueue
Date: Fri, 5 May 2017 10:58:56 +0200
Message-ID: <20170505085856.GC5008@lst.de>
References: <20170410171254.30367-1-bigeasy@linutronix.de> <20170410171254.30367-3-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53813 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755621AbdEEI66 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 5 May 2017 04:58:58 -0400
Content-Disposition: inline
In-Reply-To: <20170410171254.30367-3-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, rt@linutronix.de, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
