From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] scsi: hisi_sas: silence a static checker warning
Date: Fri, 23 Jun 2017 18:33:10 +0300
Message-ID: <20170623153310.ropr7ojz623voddu@mwanda>
References: <20170623151544.57jlfbl5apofl6hj@mwanda>
 <a72ab14c-e1ab-1cb1-1477-7d9d14d92f05@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a72ab14c-e1ab-1cb1-1477-7d9d14d92f05@huawei.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 23, 2017 at 04:25:27PM +0100, John Garry wrote:
> On 23/06/2017 16:15, Dan Carpenter wrote:
> > phy->phy_type is a u64.  We only ever use the first two bits so it's a
> > bit over kill perhaps.
> 
> Hi Dan,
> 
> Right, u64 is unneeded and u32 would suffice, so I think that would be a
> more appropriate fix. And if we change hisi_sas_phy.phy_type to u32, I would
> want to reorder this structure to improve packing efficiency.
> 
> I can make this change unless you really want to...
> 

Feel free to make the change.  :)

regards,
dan carpenter

