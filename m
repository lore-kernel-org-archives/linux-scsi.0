From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Revert "scsi-mq: Always unprepare before requeuing a request"
Date: Wed, 16 Aug 2017 20:46:50 -0400
Message-ID: <yq1d17vowat.fsf@oracle.com>
References: <20170816174324.29276-1-bart.vanassche@wdc.com>
        <yq1fucrqchu.fsf@oracle.com>
        <a757a93a-0052-e22f-b035-b8cc27256dc5@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <a757a93a-0052-e22f-b035-b8cc27256dc5@wdc.com> (Damien Le Moal's
        message of "Thu, 17 Aug 2017 09:41:15 +0900")
Sender: stable-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@wdc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Michael Ellerman <mpe@ellerman.id.au>, Brian King <brking@linux.vnet.ibm.com>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Damien,

> It means that commit 70e42fd02c46e2aa9ab07b766d418637e3a51de7 "scsi:
> sd_zbc: Write unlock zone from sd_uninit_cmnd()" will need to be
> reverted too as it will not solve the potential deadlock anymore. Bart's
> patch was needed for it to work.

OK, also dropped.

> (2) may actually be the better solution for now until I get a fix for
> blk-mq.

Yeah, that's fine with me.

-- 
Martin K. Petersen	Oracle Linux Engineering
