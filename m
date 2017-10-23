From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Suppress a kernel warning in case the prep function returns BLKPREP_DEFER
Date: Mon, 23 Oct 2017 04:21:36 -0400
Message-ID: <yq1po9el1f3.fsf@oracle.com>
References: <20171020184645.4327-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39892 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbdJWIWw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2017 04:22:52 -0400
In-Reply-To: <20171020184645.4327-1-bart.vanassche@wdc.com> (Bart Van Assche's
        message of "Fri, 20 Oct 2017 11:46:45 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> This patch avoids that the following warning is triggered when using
> the legacy block layer:

Applied to 4.14/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
