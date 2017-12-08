From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Remove scsi_dh_remove_device()
Date: Thu, 07 Dec 2017 21:14:43 -0500
Message-ID: <yq1zi6uufsc.fsf@oracle.com>
References: <20171208000059.18892-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54192 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752078AbdLHCPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2017 21:15:00 -0500
In-Reply-To: <20171208000059.18892-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Thu, 7 Dec 2017 16:00:59 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> Remove this function since it has an empty body.

Applied to 4.16/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
