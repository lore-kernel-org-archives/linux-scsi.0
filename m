From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/12] Fixes, cleanup and g_NCR5380_mmio/g_NCR5380 merger
Date: Tue, 4 Oct 2016 10:23:13 +0200
Message-ID: <bde7797c-224e-10b7-6204-d8cd48214ef9@suse.de>
References: <cover.1475559357.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1475559357.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/04/2016 07:40 AM, Finn Thain wrote:
> This patch series has fixes for compatibility, reliability and
> performance issues and some cleanup. It also includes a new version
> of Ondrej Zary's patch that merges g_NCR5380_mmio into g_NCR5380.
> 
> I've tested this patch series on a Powerbook 180. If someone would
> test some of the other platforms that would be very helpful. All
> drivers were compile-tested.
> 
> (Apologies for any duplicate messages.)
> 
> 
> Finn Thain (12):
>   scsi/g_NCR5380: Merge g_NCR5380 and g_NCR5380_mmio drivers
>   scsi/cumana_1: Remove unused cumanascsi_setup() function
>   scsi/atari_scsi: Make device register accessors re-enterant
>   scsi/ncr5380: Simplify register polling limit
>   scsi/ncr5380: Increase register polling limit
>   scsi/ncr5380: Improve hostdata struct member alignment and
>     cache-ability
>   scsi/ncr5380: Store IO ports and addresses in host private data
>   scsi/ncr5380: Use correct types for device register accessors
>   scsi/ncr5380: Pass hostdata pointer to register polling routines
>   scsi/ncr5380: Expedite register polling
>   scsi/ncr5380: Use correct types for DMA routines
>   scsi/ncr5380: Suppress unhelpful "interrupt without IRQ bit" message
> 
>  MAINTAINERS                   |   1 -
>  drivers/scsi/Kconfig          |  32 +----
>  drivers/scsi/Makefile         |   1 -
>  drivers/scsi/NCR5380.c        | 137 +++++++++++---------
>  drivers/scsi/NCR5380.h        |  87 +++++++++----
>  drivers/scsi/arm/cumana_1.c   |  98 +++++++-------
>  drivers/scsi/arm/oak.c        |  34 +++--
>  drivers/scsi/atari_scsi.c     |  77 ++++++-----
>  drivers/scsi/dmx3191d.c       |  20 +--
>  drivers/scsi/g_NCR5380.c      | 290 ++++++++++++++++++++----------------------
>  drivers/scsi/g_NCR5380.h      |  32 +----
>  drivers/scsi/g_NCR5380_mmio.c |  10 --
>  drivers/scsi/mac_scsi.c       |  83 +++++-------
>  drivers/scsi/sun3_scsi.c      |  80 ++++++------
>  14 files changed, 495 insertions(+), 487 deletions(-)
>  delete mode 100644 drivers/scsi/g_NCR5380_mmio.c
> 
For this series:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
