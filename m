From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: remove unnecessary unlikely()
Date: Mon, 17 Sep 2018 02:36:00 -0400
Message-ID: <yq1pnxcska7.fsf@oracle.com>
References: <20180905204720.992-1-igor.stoppa@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180905204720.992-1-igor.stoppa@huawei.com> (Igor Stoppa's
        message of "Wed, 5 Sep 2018 23:47:20 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Igor Stoppa <igor.stoppa@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Igor,

> BUG_ON() already contains an unlikely(), there is no need for another one.

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
