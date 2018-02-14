From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Move the eh_deadline module parameter definition to the top of hosts.c
Date: Tue, 13 Feb 2018 21:42:22 -0500
Message-ID: <yq1zi4cnvg1.fsf@oracle.com>
References: <20180212184129.25919-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46910 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966382AbeBNCmk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 21:42:40 -0500
In-Reply-To: <20180212184129.25919-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Mon, 12 Feb 2018 10:41:29 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> The eh_deadline definition occurs in the middle of the code for
> releasing a host. Avoid splitting the host release code by moving
> the definition of the eh_deadline parameter to the top of the
> hosts.c source file.

Applied to 4.17/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
