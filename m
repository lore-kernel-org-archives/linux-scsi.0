From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [REPOST PATCH 1/5] scsi: bnx2i: convert to kworker
Date: Wed, 14 Sep 2016 13:25:12 -0400
Message-ID: <yq137l2mm13.fsf@sermon.lab.mkp.net>
References: <20160817101003.30055-1-bigeasy@linutronix.de>
        <20160908123943.f7n3lurs7ovs5pup@c203.arch.suse.de>
        <yq1vay5fh2t.fsf@sermon.lab.mkp.net>
        <alpine.OSX.2.00.1609130927440.483@administrators-macbook-pro.local>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51915 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760673AbcINRZ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2016 13:25:56 -0400
In-Reply-To: <alpine.OSX.2.00.1609130927440.483@administrators-macbook-pro.local>
        (Chad Dupuis's message of "Tue, 13 Sep 2016 09:28:14 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, rt@linutronix.de, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@qlogic.com>

>>>>> "Chad" == Chad Dupuis <chad.dupuis@cavium.com> writes:

Johannes> Testing was conducted by booting from a QLogic BCM57840 CNA.

Chad> We're regression testing the patches now.  Please hold off on
Chad> applying them.

OK. I will wait.

-- 
Martin K. Petersen	Oracle Linux Engineering
