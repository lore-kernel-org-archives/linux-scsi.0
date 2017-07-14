From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 2/7] libsas: remove unused port_gone_completion
Date: Fri, 14 Jul 2017 08:40:28 +0200
Message-ID: <9dc19523-7ec3-2a86-41bb-075c58ebe51f@suse.de>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <1499670369-44143-3-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499670369-44143-3-git-send-email-wangyijing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, john.garry@huawei.com
List-Id: linux-scsi@vger.kernel.org

On 07/10/2017 09:06 AM, Yijing Wang wrote:
> No one uses the port_gone_completion in struct asd_sas_port,
> clean it out.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  include/scsi/libsas.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index c41328d..628f48b 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -263,8 +263,6 @@ struct sas_discovery {
>  /* The port struct is Class:RW, driver:RO */
>  struct asd_sas_port {
>  /* private: */
> -	struct completion port_gone_completion;
> -
>  	struct sas_discovery disc;
>  	struct domain_device *port_dev;
>  	spinlock_t dev_list_lock;
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
