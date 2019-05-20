From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2] scsi: libsas: no need to join wide port again in
 sas_ex_discover_dev()
Date: Mon, 20 May 2019 14:51:57 +0100
Message-ID: <7b7c51db-15f3-d06b-ba58-8b6ef618f7d2@huawei.com>
References: <20190520140600.22861-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190520140600.22861-1-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, miaoxie@huawei.com, zhaohongjiang@huawei.com
List-Id: linux-scsi@vger.kernel.org

On 20/05/2019 15:06, Jason Yan wrote:
> Since we are processing events synchronously now, the second call of
> sas_ex_join_wide_port() in sas_ex_discover_dev() is not needed. There
> will be no races with other works in disco workqueue. So remove the
> second sas_ex_join_wide_port().
>
> I did not change the return value of 'res' to error when discover failed
> because we need to continue to discover other phys if one phy discover
> failed. So let's keep that logic as before and just add a debug log to
> detect the failure. And directly return if second fanout expander
> attatched to the parent expander because it has nothing to do after the
> phy is disabled.
>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---

Reviewed-by: John Garry <john.garry@huawei.com>
