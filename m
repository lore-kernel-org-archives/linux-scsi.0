From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 5/7] libsas: add a new workqueue to run probe/destruct
 discovery event
Date: Fri, 14 Jul 2017 08:52:21 +0200
Message-ID: <4bd98a79-0c45-248e-8dc6-901f21612e1f@suse.de>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <1499670369-44143-6-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499670369-44143-6-git-send-email-wangyijing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, john.garry@huawei.com, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 07/10/2017 09:06 AM, Yijing Wang wrote:
> Sometimes, we want sync libsas probe or destruct in sas discovery work,
> like when libsas revalidate domain. We need to split probe and destruct
> work from the scsi host workqueue.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: Johannes Thumshirn <jthumshirn@suse.de>
> CC: Ewan Milne <emilne@redhat.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Tomas Henzl <thenzl@redhat.com>
> CC: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/libsas/sas_discover.c | 13 ++++++++++++-
>  drivers/scsi/libsas/sas_init.c     |  8 ++++++++
>  include/scsi/libsas.h              |  1 +
>  3 files changed, 21 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
