From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 3ware 9000 driver update for 2.6.7-rc2-mm2
Date: 03 Jun 2004 19:45:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086309937.1799.103.camel@mulgrave>
References: <HYPD6V00.Q4O@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:46539 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265155AbUFDApj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jun 2004 20:45:39 -0400
In-Reply-To: <HYPD6V00.Q4O@hadar.amcc.com>
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@amcc.com>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-06-02 at 17:29, Adam Radford wrote:
> 
> Andrew, James, 
> 
> This patch updates the 3w-9xxx driver in 2.6.7-rc2-mm1 to v2.26.02.000 to cleanup several things pointed out by Chris Hellwig / Jeff Garzik.
> 
> Changes in this release:
>   - Use descriptive defines for phase numbers.
>   - Remove un-needed casts for TW_Command_Full
>   - Rework eh_reset(), eh_abort() spinlocks.
>   - Remove all mdelays, replace w/ schedule_timeout().
>   - Remove MODULE_PARAM cmds_per_lun, add sysfs device attribute 'queue_depth'.
>   - Remove twa_slave_configure().
>   - Remove twa_info().
>   - Remove all bitfields from structures, add bitmask macros.
>   - Remove twa_setup_irq() wrapper, call directly.
>   - Remove un-needed prototypes.
>   - Propogate return value of pci_enable_device(), pci_set_dma_mask(), ioremap().
>   - Use pci_request/free_regions().
>   - Add missing call to pci_disable_device() on probe failure.
>   - Unregister character ioctl interface in twa_remove().
>   - Make some excessively lengthy lines < 80 columns.
>   - Use pci_module_init() instead of pci_register_driver().
>   - Remove bogus TW_IN_INTR check, fix twa_interrupt() spinlock.
>   - Rev driver branch to .02 to denote kernel version.

This patch currently rejects against my scsi-misc-2.6 tree; I assume I
have a later version which partially includes some of the changes; could
you rediff it?

Thanks,

James


