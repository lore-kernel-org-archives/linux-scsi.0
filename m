From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi-mq: Always unprepare before requeuing a request
Date: Mon, 07 Aug 2017 13:49:58 -0400
Message-ID: <yq14ltj9sjd.fsf@oracle.com>
References: <20170803214014.20332-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170803214014.20332-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Thu, 3 Aug 2017 14:40:14 -0700")
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Damien Le Moal <damien.lemoal@wdc.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Bart,

> One of the two scsi-mq functions that requeue a request unprepares a
> request before requeueing (scsi_io_completion()) but the other
> function not (__scsi_queue_insert()). Make sure that a request is
> unprepared before requeuing it.

Applied to 4.13/scsi-fixes. Thanks much!

-- 
Martin K. Petersen	Oracle Linux Engineering
