From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v5 3/7] scsi: libsas: make the event threshold
 configurable
Date: Fri, 8 Dec 2017 12:09:49 +0000
Message-ID: <89665d4a-6fbf-a936-f266-4597be124eec@huawei.com>
References: <20171208094210.24887-1-yanaijie@huawei.com>
 <20171208094210.24887-4-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171208094210.24887-4-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiyou.wangcong@gmail.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 08/12/2017 09:42, Jason Yan wrote:
> Add a sysfs attr that LLDD can configure it for every host. We made
> a example in hisi_sas. Other LLDDs using libsas can implement it if
> they want.
>
> Suggested-by: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: Johannes Thumshirn <jthumshirn@suse.de>
> CC: Ewan Milne <emilne@redhat.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Tomas Henzl <thenzl@redhat.com>
> CC: Dan Williams <dan.j.williams@intel.com>

Acked-by: John Garry <john.garry@huawei.com> #for hisi_sas part

> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c |  6 ++++++
