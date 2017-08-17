From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Revert "scsi-mq: Always unprepare before requeuing a request"
Date: Wed, 16 Aug 2017 20:52:55 -0400
Message-ID: <yq18tijow0o.fsf@oracle.com>
References: <20170816174324.29276-1-bart.vanassche@wdc.com>
        <yq1fucrqchu.fsf@oracle.com>
        <a757a93a-0052-e22f-b035-b8cc27256dc5@wdc.com>
        <3401ef29-7450-eb15-9dd1-2f021354286d@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19543 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751490AbdHQAyB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 20:54:01 -0400
In-Reply-To: <3401ef29-7450-eb15-9dd1-2f021354286d@wdc.com> (Damien Le Moal's
        message of "Thu, 17 Aug 2017 09:45:44 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@wdc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Michael Ellerman <mpe@ellerman.id.au>, Brian King <brking@linux.vnet.ibm.com>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, stable@vger.kernel.org


Damien,

> Actually, we can keep that commit as it makes the sq case cleaner
> anyway. But we need something else to prevent deadlock in the mq
> case...

OK, put it back.

Please send a lockout patch. We can always zap it if we find out what
went wrong with Bart's patch and queue a "real" fix.

-- 
Martin K. Petersen	Oracle Linux Engineering
