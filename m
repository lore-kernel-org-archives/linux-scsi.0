From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Micro-optimize READ / WRITE CDB encoding
Date: Tue, 17 Oct 2017 23:10:42 -0400
Message-ID: <yq1vajdtakt.fsf@oracle.com>
References: <20171017210352.19580-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31367 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758810AbdJRDKz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2017 23:10:55 -0400
In-Reply-To: <20171017210352.19580-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Tue, 17 Oct 2017 14:03:52 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> Only compute 'threshold' if .last_sector_bug has been set. Reduce
> the number of branches that has to be taken to check the starting
> LBA and transfer length alignment. Optimize the encoding of the
> READ(10), WRITE(10), READ(16), WRITE(16), READ(32) and WRITE(32)
> CDB encoding.

Please take a look at this. It missed 4.15 because I've been fighting a
hardware bug the last several weeks. However, I'd still like to get it
in shape for 4.16:

https://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git/log/?h=scsi-work

Feel free to beat me to it.

-- 
Martin K. Petersen	Oracle Linux Engineering
