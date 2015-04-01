From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v1] ata: ahci_xgene: Add AHCI Support for second
 generation of APM X-Gene SoC
Date: Wed, 1 Apr 2015 12:13:36 -0400
Message-ID: <20150401161336.GS9974@htj.duckdns.org>
References: <1427899682-10912-1-git-send-email-stripathi@apm.com>
 <1427899682-10912-2-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:33092 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbbDAQNk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2015 12:13:40 -0400
Content-Disposition: inline
In-Reply-To: <1427899682-10912-2-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com

On Wed, Apr 01, 2015 at 08:18:02PM +0530, Suman Tripathi wrote:
> This patch enables full AHCI feature support for APM X-Gene SoC SATA host host
> controller. The following errata's are removed:
> 
> 1. 2a0bdff6b95 ("ahci-xgene: fix the dma state machine lockup for the
>                  IDENTIFY DEVICE PIO mode command")
> 2. 09c32aaa368 ("ahci_xgene: Fix the dma state machine lockup for the
>                  ATA_CMD_SMART PIO mode command")
> 3. 1540035da71 ("ahci_xgene: Implement the xgene_ahci_poll_reg_val to
>                  support PMP")
> 4. a3a84bc7c88 ("ahci_xgene: Implement the workaround to support PMP
>                  enumeration and discovery")
> 5. 1102407bb71 ("ahci_xgene: Fix the DMA state machine lockup for the
>                  ATA_CMD_PACKET PIO mode command")
> 6. 72f79f9e35b ("ahci_xgene: Removing NCQ support from the APM X-Gene SoC
>                  AHCI SATA Host Controller driver")
> 
> In addition, enable PMP support for second generation APM X-Gene SoC.
> 
> Signed-off-by : Suman Tripathi <stripathi@apm.com>

Applied to libata/for-4.1 w/ minor edit.

> +	if (xgene_ahci_version1()) {
> +		/*
> +		 * Override the callbacks due to
> +		 * XGENE1 ERRATA's.
> +		 */

The column limit is 80 (more like 75), not 40.  I collapsed the above
into one line.

Thanks.

-- 
tejun
