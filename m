From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/5] scsi: bnx2fc: convert bnx2fc_l2_rcv_thread() to
        workqueue
Date: Fri, 5 May 2017 10:59:45 +0200
Message-ID: <20170505085945.GF5008@lst.de>
References: <20170410171254.30367-1-bigeasy@linutronix.de> <20170410171254.30367-6-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53838 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755497AbdEEI7q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 5 May 2017 04:59:46 -0400
Content-Disposition: inline
In-Reply-To: <20170410171254.30367-6-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, rt@linutronix.de, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, fcoe-devel@open-fcoe.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
