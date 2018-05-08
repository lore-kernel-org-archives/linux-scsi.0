From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] zfcp: fix infinite iteration on ERP ready list
Date: Tue, 08 May 2018 00:02:18 -0400
Message-ID: <yq1d0y6ztf9.fsf@oracle.com>
References: <20180503115247.12859-1-maier@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180503115247.12859-1-maier@linux.ibm.com> (Steffen Maier's
        message of "Thu, 3 May 2018 13:52:47 +0200")
Sender: stable-owner@vger.kernel.org
To: Steffen Maier <maier@linux.ibm.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Remus <jremus@linux.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Steffen,

> zfcp_erp_adapter_reopen() schedules blocking of all of the adapter's
> rports via zfcp_scsi_schedule_rports_block() and enqueues a reopen
> adapter ERP action via zfcp_erp_action_enqueue(). Both are separately
> processed asynchronously and concurrently.

Applied to 4.17/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
