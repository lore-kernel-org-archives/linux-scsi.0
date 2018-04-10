From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] qla2xxx: correctly shift host byte
Date: Mon, 09 Apr 2018 21:17:59 -0400
Message-ID: <yq1muyb3lmg.fsf@oracle.com>
References: <20180409122423.32231-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180409122423.32231-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Mon, 9 Apr 2018 14:24:23 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Johannes,

> The SCSI host byte has to be shifted by 16 not 6.
>
> As Bart pointed out this patch does not change any functionality
> because DID_OK == 0, but a wrong shift is irritating for the reviewer.

Applied to 4.17/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
