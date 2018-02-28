From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] Avoid that ATA error handling can trigger a kernel hang or oops
Date: Tue, 27 Feb 2018 21:14:23 -0500
Message-ID: <yq1a7vt6etc.fsf@oracle.com>
References: <20180222193020.30276-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180222193020.30276-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Thu, 22 Feb 2018 11:30:20 -0800")
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Natanael Copa <ncopa@alpinelinux.org>, Damien Le Moal <damien.lemoal@wdc.com>, Alexandre Oliva <oliva@gnu.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Bart,

> Avoid that the recently introduced call_rcu() call in the SCSI core
> triggers a double call_rcu() call.

Applied to 4.16/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
