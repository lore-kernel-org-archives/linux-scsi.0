From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v2 00/12] Fixes, cleanup and g_NCR5380_mmio/g_NCR5380 merger
Date: Fri, 7 Oct 2016 19:59:39 +0200
Message-ID: <201610071959.39619.linux@rainbow-software.org>
References: <cover.1475791899.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1475791899.git.fthain@telegraphics.com.au>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday 07 October 2016 01:41:06 Finn Thain wrote:
> This patch series has fixes for compatibility, reliability and
> performance issues and some cleanup. It also includes a new version
> of Ondrej Zary's patch that merges g_NCR5380_mmio into g_NCR5380.
>
> I've tested this patch series on a Powerbook 180. If someone would
> test some of the other platforms that would be very helpful. All
> drivers were compile-tested.
>
> Changes since v1:
> - rebased on 4.9/scsi-queue
> - added reviewed-by tags
> - tweaked the order of struct members in patch 7/12
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

Tested on HP C2502 (53C400A chip), Canon FG2-5202 (53C400 chip) and DTC-3181L
(DTCT-436P chip) ISA cards - everything works fine!

Thanks.

Tested-by: Ondrej Zary <linux@rainbow-software.org>


-- 
Ondrej Zary
