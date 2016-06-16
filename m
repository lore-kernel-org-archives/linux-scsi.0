From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH V2 resend] libata:fix kernel panic when hotplug
Date: Thu, 16 Jun 2016 16:20:45 -0400
Message-ID: <20160616202045.GF3262@mtj.duckdns.org>
References: <1466052340-25520-1-git-send-email-dingxiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466052340-25520-1-git-send-email-dingxiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: DingXiang <dingxiang@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, fangwei1@huawei.com, miaoxie@huawei.com, wangyijing@huawei.com, zhangaihua1@huawei.com, zhaohongjiang@huawei.com, houtao1@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 16, 2016 at 12:45:40PM +0800, DingXiang wrote:
...
> In fact,we don't need libata to deal with hotplug in sas environment.
> So we can't run ata hotplug task when ata port is sas host.

Martin, can you please confirm whether the above is true.  If so, I'll
route the patch through libata w/ stable cc'd.

Thanks.

-- 
tejun
