From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/2] scsi: fix race between simultaneous decrements of
 ->host_failed
Date: Tue, 31 May 2016 10:33:02 -0400
Message-ID: <20160531143302.GA4251@mtj.duckdns.org>
References: <1464683898-9877-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464683898-9877-1-git-send-email-fangwei1@huawei.com>
Sender: linux-doc-owner@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, corbet@lwn.net, hch@infradead.org, dan.j.williams@intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, May 31, 2016 at 04:38:17PM +0800, Wei Fang wrote:
> sas_ata_strategy_handler() adds the works of the ata error handler
> to system_unbound_wq. This workqueue asynchronously runs work items,

Are there more than one error handling work items per host?

Thanks.

-- 
tejun
