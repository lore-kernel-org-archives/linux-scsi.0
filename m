Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A912C2BB55
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 13:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F569206E9
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 13:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895019AbgDPNQH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 09:16:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:40156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2894852AbgDPNQG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 09:16:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B1F4EAC6D;
        Thu, 16 Apr 2020 13:15:15 +0000 (UTC)
Date:   Thu, 16 Apr 2020 15:15:15 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v3 30/31] elx: efct: Add Makefile and Kconfig for efct
 driver
Message-ID: <20200416131515.2p5lj4inqnjzob4w@carbon>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-31-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412033303.29574-31-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 11, 2020 at 08:33:02PM -0700, James Smart wrote:
> This patch completes the efct driver population.
> 
> This patch adds driver definitions for:
> Adds the efct driver Kconfig and Makefiles
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>   Use SPDX license
>   Remove utils.c from makefile
> ---
>  drivers/scsi/elx/Kconfig  |  9 +++++++++
>  drivers/scsi/elx/Makefile | 18 ++++++++++++++++++
>  2 files changed, 27 insertions(+)
>  create mode 100644 drivers/scsi/elx/Kconfig
>  create mode 100644 drivers/scsi/elx/Makefile
> 
> diff --git a/drivers/scsi/elx/Kconfig b/drivers/scsi/elx/Kconfig
> new file mode 100644
> index 000000000000..831daea7a951
> --- /dev/null
> +++ b/drivers/scsi/elx/Kconfig
> @@ -0,0 +1,9 @@
> +config SCSI_EFCT
> +	tristate "Emulex Fibre Channel Target"
> +	depends on PCI && SCSI
> +	depends on TARGET_CORE
> +	depends on SCSI_FC_ATTRS
> +	select CRC_T10DIF
> +	help
> +	  The efct driver provides enhanced SCSI Target Mode
> +	  support for specific SLI-4 adapters.

The help text could be more verbose. The rest looks good.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
