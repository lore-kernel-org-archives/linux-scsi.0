From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Revert "scsi-mq: Always unprepare before requeuing a request"
Date: Wed, 16 Aug 2017 20:11:41 -0400
Message-ID: <yq1fucrqchu.fsf@oracle.com>
References: <20170816174324.29276-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41367 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751601AbdHQAMG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 20:12:06 -0400
In-Reply-To: <20170816174324.29276-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Wed, 16 Aug 2017 10:43:24 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Damien Le Moal <damien.lemoal@wdc.com>, Johannes Thumshirn <jthumshirn@suse.de>, Michael Ellerman <mpe@ellerman.id.au>, Brian King <brking@linux.vnet.ibm.com>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, stable@vger.kernel.org


Bart,

> For an unknown reason this patch causes the boot process to hang on
> PowerPC systems:

OK, dropped it from fixes for now.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
