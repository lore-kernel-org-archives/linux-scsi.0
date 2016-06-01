From: Wei Fang <fangwei1@huawei.com>
Subject: Re: [PATCH v2 1/2] scsi: fix race between simultaneous decrements of
 ->host_failed
Date: Wed, 1 Jun 2016 09:20:38 +0800
Message-ID: <574E3866.50108@huawei.com>
References: <1464683898-9877-1-git-send-email-fangwei1@huawei.com>
 <20160531143302.GA4251@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160531143302.GA4251@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, corbet@lwn.net, hch@infradead.org, dan.j.williams@intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi, Tejun,

On 2016/5/31 22:33, Tejun Heo wrote:
> On Tue, May 31, 2016 at 04:38:17PM +0800, Wei Fang wrote:
>> sas_ata_strategy_handler() adds the works of the ata error handler
>> to system_unbound_wq. This workqueue asynchronously runs work items,
> 
> Are there more than one error handling work items per host?

The ata error handler here means async_sas_ata_eh(), every port will
execute it's own async_sas_ata_eh() in sas_ata_strategy_handler().

Thanks,
Wei

> 
> Thanks.
> 

