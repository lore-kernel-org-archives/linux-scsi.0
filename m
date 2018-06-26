From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] ata: Fix ZBC_OUT all bit handling
Date: Tue, 26 Jun 2018 19:38:14 +0800
Message-ID: <20180626113814.GB29708@kroah.com>
References: <20180626071838.15140-1-damien.lemoal@wdc.com>
 <20180626071838.15140-3-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180626071838.15140-3-damien.lemoal@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 26, 2018 at 04:18:38PM +0900, Damien Le Moal wrote:
> If the ALL bit is set in the ZBC_OUT command, the command zone ID field
> (block) should be ignored.
> 
> Reported-by: David Butterfield <david.butterfield@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/ata/libata-scsi.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
