From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: scsi_dh_alua: Fix possible null-ptr-deref
Date: Wed, 29 May 2019 22:04:57 -0400
Message-ID: <yq1zhn4y9x2.fsf@oracle.com>
References: <20190527142209.21768-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190527142209.21768-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Mon, 27 May 2019 22:22:09 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, bvanassche@acm.org, axboe@kernel.dk, hare@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


YueHaibing,

> If alloc_workqueue fails in alua_init, it should return -ENOMEM,
> otherwise it will trigger null-ptr-deref while unloading module which
> calls destroy_workqueue dereference wq->lock like this:

Applied to 5.2/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
