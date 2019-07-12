From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libfc: fix null pointer dereference on a null lport
Date: Thu, 11 Jul 2019 21:47:40 -0400
Message-ID: <yq1h87s58hv.fsf@oracle.com>
References: <20190702091835.13629-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190702091835.13629-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 2 Jul 2019 10:18:35 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Colin King <colin.king@canonical.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hannes,

Please review!

> Currently if lport is null then the null lport pointer is dereference
> when printing out debug via the FC_LPORT_DB macro. Fix this by using
> the more generic FC_LIBFC_DBG debug macro instead that does not use
> lport.

-- 
Martin K. Petersen	Oracle Linux Engineering
