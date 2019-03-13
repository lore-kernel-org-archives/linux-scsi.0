From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] aacraid: Fix performance issue (QD) on logical
 drives
Date: Wed, 13 Mar 2019 15:45:53 -0700
Message-ID: <20190313224553.GA8102@kroah.com>
References: <1552519284-1512-1-git-send-email-sagar.biradar@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1552519284-1512-1-git-send-email-sagar.biradar@microchip.com>
Sender: stable-owner@vger.kernel.org
To: Sagar Biradar <sagar.biradar@microchip.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, aacraid@microsemi.com, Dave Carroll <david.carroll@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Brian King <brking@linux.vnet.ibm.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 13, 2019 at 04:21:24PM -0700, Sagar Biradar wrote:
> Fix performance issue where the queue depth for SmartIOC logical
> volumes is set to 1, and allow the usual logical volume code
> to be executed
> 
> Fixes: a052865fe2871a3888 (aacraid: Set correct Queue Depth for HBA1000
> RAW disks)
> 
> Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
> Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
> ---
>  drivers/scsi/aacraid/linit.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
