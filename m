From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 3/3] scsi-mq-debugfs: Show more information
Date: Mon, 08 Jan 2018 22:11:22 -0500
Message-ID: <yq1fu7fohet.fsf@oracle.com>
References: <20171206005753.28734-1-bart.vanassche@wdc.com>
        <20171206005753.28734-4-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35270 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbeAIDMJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2018 22:12:09 -0500
In-Reply-To: <20171206005753.28734-4-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Tue, 5 Dec 2017 16:57:53 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> Show the request result, request timeout and SCSI command flags.
> This information is very helpful when trying to figure out why a
> queue got stuck. An example of the information that is exported
> through debugfs:

Applied to 4.16/scsi-fixes, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
