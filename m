From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v3 07/12] scsi/ncr5380: Store IO ports and addresses in
 host private data
Date: Mon, 10 Oct 2016 10:19:49 +0100
Message-ID: <20161010091949.GZ1041@n2100.armlinux.org.uk>
References: <cover.1476051961.git.fthain@telegraphics.com.au>
 <5c9f6b4913bc8bc4938d2de0bb19d4289226ec26.1476051962.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5c9f6b4913bc8bc4938d2de0bb19d4289226ec26.1476051962.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-kernel@lists.infradead.org, Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 10, 2016 at 12:46:53AM -0400, Finn Thain wrote:
> The various 5380 drivers inconsistently store register pointers
> either in the Scsi_Host struct "legacy crap" area or in special,
> board-specific members of the NCR5380_hostdata struct. Uniform
> use of the latter struct makes for simpler and faster code (see
> the following patches) and helps to reduce use of the
> NCR5380_implementation_fields macro.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Tested-by: Ondrej Zary <linux@rainbow-software.org>
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>
> ---
>  drivers/scsi/arm/cumana_1.c | 60 ++++++++++++++++++++--------------------
>  drivers/scsi/arm/oak.c      | 23 ++++++++--------

For these two,

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
