From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: sg: don't return bogus Sg_requests
Date: Thu, 11 May 2017 23:15:34 -0400
Message-ID: <yq1bmqyix49.fsf@oracle.com>
References: <20170510075340.12125-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170510075340.12125-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Wed, 10 May 2017 09:53:40 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Andrey Konovalov <andreyknvl@google.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Doug Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org


Johannes,

> If the list search in sg_get_rq_mark() fails to find a valid request,
> we return a bogus element. This then can later lead to a GPF in
> sg_remove_scat().
>
> So don't return bogus Sg_requests in sg_get_rq_mark() but NULL in case
> the list search doesn't find a valid request.

Applied to 4.12/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
