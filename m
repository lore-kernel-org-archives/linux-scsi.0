From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] device information: Do not interpret error codes as flags
Date: Wed, 15 Nov 2017 18:57:03 -0500
Message-ID: <yq1inebqenk.fsf@oracle.com>
References: <20171115023317.3595-1-bart.vanassche@wdc.com>
        <20171115023317.3595-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28772 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750967AbdKOX5T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2017 18:57:19 -0500
In-Reply-To: <20171115023317.3595-2-bart.vanassche@wdc.com> (Bart Van Assche's
        message of "Tue, 14 Nov 2017 18:33:15 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>


Hi Bart,

> This patch also avoids that error codes returned by
> scsi_get_device_flags_keyed() are interpret as device flags.

Nobody expects this and scsi_get_device_flags() to ever return an
error. So I'd rather have the != -ENOENT case fixed up to return 0.

-- 
Martin K. Petersen	Oracle Linux Engineering
