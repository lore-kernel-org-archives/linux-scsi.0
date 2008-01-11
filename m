From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH] cciss: section mismatch
Date: Fri, 11 Jan 2008 15:14:19 +0000
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE19506934@G6W0268.americas.hpqcorp.net>
References: <20080110143235.b65d5f19.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:19128 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbYAKPPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 10:15:03 -0500
In-Reply-To: <20080110143235.b65d5f19.randy.dunlap@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>, ISS StorageDev <iss_storagedev@hp.com>
Cc: akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>, "axboe@kernel.dk" <axboe@kernel.dk>

> --- linux-2.6.24-rc7-git1.orig/drivers/block/cciss.c
> +++ linux-2.6.24-rc7-git1/drivers/block/cciss.c
> @@ -2927,7 +2927,7 @@ default_int_mode:
>         return;
>  }
>
> -static int cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
> +static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev
> +*pdev)
>  {
>         ushort subsystem_vendor_id, subsystem_device_id, command;
>         __u32 board_id, scratchpad = 0;
>

Thanks, Randy.
