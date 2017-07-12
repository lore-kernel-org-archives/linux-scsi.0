From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: sg: fix SG_DXFER_FROM_DEV transfers
Date: Wed, 12 Jul 2017 17:17:59 -0400
Message-ID: <yq1a849l5h4.fsf@oracle.com>
References: <20170707085638.18939-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170707085638.18939-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Fri, 7 Jul 2017 10:56:38 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Chris Clayton <chris2553@googlemail.com>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org


Johannes,

> SG_DXFER_FROM_DEV transfers do not necessarily have a dxferp as we set
> it to NULL for the old sg_io read/write interface, but must have a
> length bigger than 0. This fixes a regression introduced by commit
> 28676d869bbb ("scsi: sg: check for valid direction before starting the
> request")

Applied to 4.13/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
