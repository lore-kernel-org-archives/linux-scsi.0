From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v3 11/12] scsi/ncr5380: Use correct types for DMA routines
Date: Mon, 10 Oct 2016 10:15:41 +0100
Message-ID: <20161010091541.GX1041@n2100.armlinux.org.uk>
References: <cover.1476051961.git.fthain@telegraphics.com.au>
 <8390541e30d7b7cd418a7b5095fdb4b5fc7aa0ed.1476051962.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <8390541e30d7b7cd418a7b5095fdb4b5fc7aa0ed.1476051962.git.fthain@telegraphics.com.au>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 10, 2016 at 12:46:53AM -0400, Finn Thain wrote:
> Apply prototypes to get consistent function signatures for the DMA
> functions implemented in the board-specific drivers. To avoid using
> macros to alter actual parameters, some of those functions are reworked
> slightly.
> 
> This is a step toward the goal of passing the board-specific routines
> to the core driver using an ops struct (as in a platform driver or
> library module).
> 
> This also helps fix some inconsistent types: where the core driver uses
> ints (cmd->SCp.this_residual and hostdata->dma_len) for keeping track of
> transfers, certain board-specific routines used unsigned long.
> 
> While we are fixing these function signatures, pass the hostdata pointer
> to DMA routines instead of a Scsi_Host pointer, for shorter and faster
> code.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Tested-by: Ondrej Zary <linux@rainbow-software.org>
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>
> ---
>  drivers/scsi/arm/cumana_1.c | 26 ++++++++++------
>  drivers/scsi/arm/oak.c      | 13 ++++----

For these two,

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
