From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] Introduce a type for device information flags, namely bflags_t
Date: Wed, 15 Nov 2017 19:00:24 -0500
Message-ID: <yq1efozqehz.fsf@oracle.com>
References: <20171115023317.3595-1-bart.vanassche@wdc.com>
        <20171115023317.3595-4-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20473 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932182AbdKPABp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2017 19:01:45 -0500
In-Reply-To: <20171115023317.3595-4-bart.vanassche@wdc.com> (Bart Van Assche's
        message of "Tue, 14 Nov 2017 18:33:17 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> +typedef __u32 __bitwise bflags_t;

Since we're already out of flags, let's not perpetuate the u32
limitation.

-- 
Martin K. Petersen	Oracle Linux Engineering
