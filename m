From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/6] mvsas: remove the SAS host after the SCSI host
Date: Wed, 29 Mar 2017 12:18:26 +0200
Message-ID: <2f920f25-866a-7ffd-4bae-4806fb4eec75@suse.de>
References: <cover.1490775958.git.jthumshirn@suse.de>
 <20170329094122.9997-3-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170329094122.9997-3-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, Dan Williams <dan.j.williams@intel.com>, John Garry <john.garry@huawei.com>, Jack Wang <jinpu.wang@profitbricks.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 03/29/2017 11:41 AM, Johannes Thumshirn wrote:
> After commit bcdde7e ("sysfs: make __sysfs_remove_dir() recursive") changed the
> removal path of kernfs to make it recursive we have to remove the SAS host
> before the SCSI host or we will see sysfs warnings on not found sysfs groups for
> kobjects.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/mvsas/mv_init.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
