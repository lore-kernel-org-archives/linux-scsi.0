From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: cxlflash: Prevent deadlock when adapter probe fails
Date: Mon, 04 Feb 2019 22:24:37 -0500
Message-ID: <yq1imxy3oju.fsf@oracle.com>
References: <20190130122651.19255-1-vaibhav@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190130122651.19255-1-vaibhav@linux.ibm.com> (Vaibhav Jain's
        message of "Wed, 30 Jan 2019 17:56:51 +0530")
Sender: stable-owner@vger.kernel.org
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: "Manoj N . Kumar" <manoj@linux.ibm.com>, "Matthew R . Ochs" <mrochs@linux.ibm.com>, Uma Krishnan <ukrishn@linux.ibm.com>, Frederic Barrat <fbarrat@linux.ibm.com>, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Vaibhav,

> Presently when an error is encountered during probe of the cxlflash
> adapter, a deadlock is seen with cpu thread stuck inside
> cxlflash_remove(). Below is the trace of the deadlock as logged by
> khungtaskd:

Applied to 5.0/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
