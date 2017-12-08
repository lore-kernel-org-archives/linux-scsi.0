From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Unexport scsi_initialize_rq()
Date: Thu, 07 Dec 2017 21:13:05 -0500
Message-ID: <yq14lp2vufi.fsf@oracle.com>
References: <20171207235931.18314-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49354 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752346AbdLHCNS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2017 21:13:18 -0500
In-Reply-To: <20171207235931.18314-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Thu, 7 Dec 2017 15:59:31 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> Commit 651a01364994 ("scsi: scsi_transport_sas: switch to bsg-lib for
> SMP passthrough") removed the only call to scsi_initialize_rq() from
> outside the SCSI core. Hence unexport scsi_initialize_rq().

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
