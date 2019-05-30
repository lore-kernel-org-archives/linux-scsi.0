From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: libsas: no need to join wide port again in sas_ex_discover_dev()
Date: Wed, 29 May 2019 22:11:38 -0400
Message-ID: <yq1muj4y9lx.fsf@oracle.com>
References: <20190520140600.22861-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190520140600.22861-1-yanaijie@huawei.com> (Jason Yan's message
        of "Mon, 20 May 2019 22:06:00 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, miaoxie@huawei.com, john.garry@huawei.com, zhaohongjiang@huawei.com
List-Id: linux-scsi@vger.kernel.org


Jason,

> Since we are processing events synchronously now, the second call of
> sas_ex_join_wide_port() in sas_ex_discover_dev() is not needed. There
> will be no races with other works in disco workqueue. So remove the
> second sas_ex_join_wide_port().

Applied to 5.3/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
