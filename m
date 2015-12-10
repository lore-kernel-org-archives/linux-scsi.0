From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] hisi_sas: fix error codes in hisi_sas_task_prep()
Date: Thu, 10 Dec 2015 13:17:18 -0500
Message-ID: <yq1vb861841.fsf@sermon.lab.mkp.net>
References: <20151209104836.GK3173@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20151209104836.GK3173@mwanda> (Dan Carpenter's message of "Wed,
	9 Dec 2015 13:48:36 +0300")
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> There were a couple cases where the error codes weren't set and
Dan> also I changed the success return to "return 0;" which is the same
Dan> as "return rc;" but more explicit.

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
