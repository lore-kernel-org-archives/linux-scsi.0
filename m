From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sg: only check for dxfer_len greater than 256M
Date: Thu, 27 Jul 2017 08:51:56 -0400
Message-ID: <yq1mv7qvy8j.fsf@oracle.com>
References: <20170727071126.4717-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170727071126.4717-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Thu, 27 Jul 2017 09:11:26 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Jason L Tibbitts III <tibbs@math.uh.edu>, Doug Gilbert <dgilbert@interlog.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Johannes,

> Don't make any assumptions on the sg_io_hdr_t::dxfer_direction or the
> sg_io_hdr_t::dxferp in order to determine if it is a valid
> request. The only way we can check for bad requests is by checking if
> the length exceeds 256M.

Applied to 4.13/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
