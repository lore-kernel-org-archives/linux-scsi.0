From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: don't look for NULL devices handlers by name
Date: Wed, 28 Mar 2018 18:16:57 -0400
Message-ID: <yq1bmf7hmli.fsf@oracle.com>
References: <20180323133705.14556-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180323133705.14556-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Fri, 23 Mar 2018 14:37:05 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org


Johannes,

> Currently scsi_dh_lookup() doesn't check for NULL as a device
> name. This combined with nvme over dm-mapth results in the following
> messages emitted by device-mapper:

Applied to 4.16/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
