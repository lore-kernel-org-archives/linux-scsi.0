From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libsas: remove the exporting of sas_wait_eh
Date: Thu, 11 Jul 2019 20:34:18 -0400
Message-ID: <yq1ftnc8511.fsf@oracle.com>
References: <20190708164339.14465-1-efremov@linux.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190708164339.14465-1-efremov@linux.com> (Denis Efremov's
        message of "Mon, 8 Jul 2019 19:43:39 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Denis Efremov <efremov@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Denis,

> The function sas_wait_eh is declared static and marked
> EXPORT_SYMBOL, which is at best an odd combination. Because the
> function is not used outside of the drivers/scsi/libsas/sas_scsi_host.c
> file it is defined in, this commit removes the EXPORT_SYMBOL() marking.

Applied to 5.3/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
