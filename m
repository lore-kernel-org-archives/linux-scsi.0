From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/5] scsi: libsas: check the lldd callback correctly
Date: Thu, 20 Sep 2018 08:34:09 +0200
Message-ID: <20180920063409.GE12913@lst.de>
References: <20180919033204.11102-1-yanaijie@huawei.com> <20180919033204.11102-3-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180919033204.11102-3-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, miaoxie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 19, 2018 at 11:32:01AM +0800, Jason Yan wrote:
> We are using lldd_port_deformed so we'd better check if lldd_port_deformed
> is NULL.
> 
> After this, we can remove hisi_sas_port_deformed() because it is just a
> stub to avoid a NULL dereference caused by the wrong check.
> 

The wording seems a bit odd.  I'd do something like:

libsas: make the lldd_port_deformed method optional

... and remove the dummy implementation in hisi_sas.


Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
