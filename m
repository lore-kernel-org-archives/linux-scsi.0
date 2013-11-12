From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 0/5] ata: Add APM X-Gene SATA controller support
Date: Tue, 12 Nov 2013 16:40:12 +0100
Message-ID: <3056580.hyyOnlSqg9@amdc1032>
References: <1383980431-6572-1-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:12475 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3KLPkZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2013 10:40:25 -0500
In-reply-to: <1383980431-6572-1-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Loc Ho <lho@apm.com>, olof@lixom.net, tj@kernel.org, linux-scsi@vger.kernel.org, jcm@redhat.com, Suman Tripathi <stripathi@apm.com>, Tuan Phan <tphan@apm.com>, linux-ide@vger.kernel.org


Hi,

Please remember to include linux-ide@vger.kernel.org on CC: for ATA patches.

Also from the quick look it seems that:
- patch #4 ("ata: Add APM X-Gene SATA serdes functions") should come before
  patch #3 ("ata: Add APM X-Gene SATA driver") as code in patch #3 depends
  on the code in patch #4
- patch #5 ("Documentation: Add documentation for APM X-Gene SATA DTS
  binding") should come before patch #2 ("arm64: Add APM X-Gene DTS entry
  for SATA controllers") or (even better) just be merged into patch #2

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Saturday, November 09, 2013 12:00:26 AM Loc Ho wrote:
> ata: Add APM X-Gene SATA controller support
> 
> v2:
>  * Clean up file sata_xgene.c with Lindent and etc
>  * Clean up file sata_xgene_serdes.c with Lindent and etc
>  * Add description to each patch
> 
> v1:
>  * inital version
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
> Loc Ho (5):
>   ata: Export AHCI library functions required by APM X-Gene SATA driver
>   arm64: Add APM X-Gene DTS entry for SATA controllers
>   ata: Add APM X-Gene SATA driver
>   ata: Add APM X-Gene SATA serdes functions
>   Documentation: Add documentation for APM X-Gene SATA DTS binding
> 
>  .../devicetree/bindings/ata/apm-xgene.txt          |   84 +
>  arch/arm64/boot/dts/apm-storm.dtsi                 |   73 +
>  drivers/ata/Kconfig                                |    7 +
>  drivers/ata/Makefile                               |    2 +
>  drivers/ata/ahci.h                                 |    6 +
>  drivers/ata/libahci.c                              |   13 +-
>  drivers/ata/sata_xgene.c                           | 1394 ++++++++++++++
>  drivers/ata/sata_xgene.h                           |  112 ++
>  drivers/ata/sata_xgene_serdes.c                    | 2004 ++++++++++++++++++++
>  9 files changed, 3690 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt
>  create mode 100644 drivers/ata/sata_xgene.c
>  create mode 100644 drivers/ata/sata_xgene.h
>  create mode 100644 drivers/ata/sata_xgene_serdes.c
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

