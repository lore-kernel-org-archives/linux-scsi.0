From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 2/5] scsi: libsas: check the lldd callback correctly
Date: Mon, 17 Sep 2018 09:11:49 +0100
Message-ID: <ac858677-0606-665a-44fb-4042e81e83aa@huawei.com>
References: <20180912082946.34814-1-yanaijie@huawei.com>
 <20180912082946.34814-3-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180912082946.34814-3-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, miaoxie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 12/09/2018 09:29, Jason Yan wrote:
> We are using lldd_port_deformed so we'd better check if lldd_port_deformed
> is NULL.
>
> After this, we can remove hisi_sas_port_deformed() because it is just a
> stub to avoid a NULL dereference caused by the wrong check.
>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Acked-by: John Garry <john.garry@huawei.com>

> CC: John Garry <john.garry@huawei.com>
> CC: Johannes Thumshirn <jthumshirn@suse.de>
> CC: Ewan Milne <emilne@redhat.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Tomas Henzl <thenzl@redhat.com>
> CC: Dan Williams <dan.j.williams@intel.com>
> CC: Hannes Reinecke <hare@suse.com>
> ---
