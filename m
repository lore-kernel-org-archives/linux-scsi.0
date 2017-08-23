From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sg: off by one in sg_ioctl()
Date: Tue, 22 Aug 2017 22:24:14 -0400
Message-ID: <yq18tibaunl.fsf@oracle.com>
References: <20170817070954.d4gg7hqgg2qjf6d3@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170817070954.d4gg7hqgg2qjf6d3@mwanda> (Dan Carpenter's message
        of "Thu, 17 Aug 2017 10:09:54 +0300")
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Doug Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Dan,

> If "val" is SG_MAX_QUEUE then we are one element beyond the end of the
> "rinfo" array so the > should be >=.

Applied to 4.13/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
