From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hisi_sas: add null check before indirect pointer dereference
Date: Tue, 23 May 2017 22:03:44 -0400
Message-ID: <yq1wp97vwn3.fsf@oracle.com>
References: <20170522180029.GA19381@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170522180029.GA19381@embeddedgus> (Gustavo A. R. Silva's
        message of "Mon, 22 May 2017 13:00:29 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo A.,

> Add null check before indirectly dereferencing pointer task->lldd_task
> in statement u32 tag = slot->idx;

Applied to 4.13/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
