From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v3 08/12] scsi/ncr5380: Use correct types for device
 register accessors
Date: Mon, 10 Oct 2016 10:13:47 +0100
Message-ID: <20161010091347.GW1041@n2100.armlinux.org.uk>
References: <cover.1476051961.git.fthain@telegraphics.com.au>
 <7f9f43fa2d3ba08a3277b749ea38acad3c8e8337.1476051962.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <7f9f43fa2d3ba08a3277b749ea38acad3c8e8337.1476051962.git.fthain@telegraphics.com.au>
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
> For timeout values adopt unsigned long, which is the type of jiffies etc.
> 
> For chip register values and bit masks pass u8, which is the return type
> of readb, inb etc.
> 
> For device register offsets adopt unsigned int, as it is suitable for
> adding to base addresses.
> 
> Pass the NCR5380_hostdata pointer to the board-specific routines instead
> of the Scsi_Host pointer. The board-specific code is concerned with
> hardware and not with SCSI protocol or the mid-layer.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Tested-by: Ondrej Zary <linux@rainbow-software.org>
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>
> ---
>  drivers/scsi/arm/cumana_1.c | 20 +++++++++++---------
>  drivers/scsi/arm/oak.c      |  6 ++----

For these two:

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
