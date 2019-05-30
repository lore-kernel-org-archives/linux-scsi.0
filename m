From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: libsas: only clear phy->in_shutdown after shutdown event done
Date: Wed, 29 May 2019 22:09:58 -0400
Message-ID: <yq1r28gy9op.fsf@oracle.com>
References: <20190514024239.47313-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190514024239.47313-1-yanaijie@huawei.com> (Jason Yan's message
        of "Tue, 14 May 2019 10:42:38 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, miaoxie@huawei.com, john.garry@huawei.com, zhaohongjiang@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org


Jason,

> When the event queue is full of phy up and down events and reached the
> threshold, we will queue a shutdown-event, and set phy->in_shutdown so
> that we will not queue a shutdown-event again. But before the
> shutdown-event can be executed, every phy-down event will clear
> phy->in_shutdown and a new shutdown-event will be queued. The queue will
> be full of these shutdown-events.
>
> Fix this by only clear phy->in_shutdown in sas_phye_shutdown(), that is
> after the first shutdown-event has been executed.

Applied 1+2 to 5.2/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
