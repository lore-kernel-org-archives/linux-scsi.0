From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sg: fix static checker warning in sg_is_valid_dxfer
Date: Mon, 17 Jul 2017 23:04:14 -0400
Message-ID: <yq1fudufntd.fsf@oracle.com>
References: <20170717131142.14069-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170717131142.14069-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Mon, 17 Jul 2017 15:11:42 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Colin Ian King <colin.king@canonical.com>, Dan Carpenter <dan.carpenter@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org


Johannes,

> dxfer_len is an unsigned int and we always assign a value > 0 to it,
> so it doesn't make any sense to check if it is < 0. We can't really
> check dxferp as well as we have both NULL and not NULL cases in the
> possible call paths.
>
> So just return true for SG_DXFER_FROM_DEV transfer in
> sg_is_valid_dxfer().

Applied to 4.13/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
