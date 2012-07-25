From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [resend PATCH 5/5] libsas, ipr: cleanup ata_host flags initialization
 via ata_host_init
Date: Wed, 25 Jul 2012 14:42:54 -0400
Message-ID: <50103E2E.40300@pobox.com>
References: <20120710040434.26529.86552.stgit@dwillia2-linux.jf.intel.com> <20120710040608.26529.20117.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120710040608.26529.20117.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/10/2012 12:06 AM, Dan Williams wrote:
> libsas and ipr pass flags to ata_host_init that are meant for the port.
>
> ata_host flags:
> 	ATA_HOST_SIMPLEX	= (1 << 0),	/* Host is simplex, one DMA channel per host only */
> 	ATA_HOST_STARTED	= (1 << 1),	/* Host started */
> 	ATA_HOST_PARALLEL_SCAN	= (1 << 2),	/* Ports on this host can be scanned in parallel */
> 	ATA_HOST_IGNORE_ATA	= (1 << 3),	/* Ignore ATA devices on this host. */
>
> flags passed by libsas:
> 	ATA_FLAG_SATA		= (1 << 1),
> 	ATA_FLAG_PIO_DMA	= (1 << 7), /* PIO cmds via DMA */
> 	ATA_FLAG_NCQ		= (1 << 10), /* host supports NCQ */
>
> The only one that aliases is ATA_HOST_STARTED which is a 'don't care' in
> the libsas and ipr cases since ata_hosts from these sources are not
> registered with libata.
>
> Cc: Brian King <brking@us.ibm.com>
> Reported-by: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>   drivers/ata/libata-core.c     |   10 ++--------
>   drivers/scsi/ipr.c            |    3 +--
>   drivers/scsi/libsas/sas_ata.c |    5 +----
>   include/linux/libata.h        |    3 +--

Acked-by: Jeff Garzik <jgarzik@redhat.com>




