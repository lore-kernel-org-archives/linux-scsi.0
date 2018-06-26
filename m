From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] ata: Fix ZBC_OUT command block check
Date: Tue, 26 Jun 2018 19:38:07 +0800
Message-ID: <20180626113807.GA29708@kroah.com>
References: <20180626071838.15140-1-damien.lemoal@wdc.com>
 <20180626071838.15140-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180626071838.15140-2-damien.lemoal@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 26, 2018 at 04:18:37PM +0900, Damien Le Moal wrote:
> The block (LBA) specified must not exceed the last addressable LBA,
> which is dev->nr_sectors - 1. So fix the correct check is
> "if (block >= dev->n_sectors)" and not "if (block > dev->n_sectords)".
> 
> Additionally, the asc/ascq to return for an LBA that is not a zone start
> LBA should be ILLEGAL REQUEST, regardless if the bad LBA is out of
> range.
> 
> Reported-by: David Butterfield <david.butterfield@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
