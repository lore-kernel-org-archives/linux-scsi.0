From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: megasas: failed to get PD list
Date: Fri, 18 Jul 2014 17:24:50 +0530
Message-ID: <4f971f88b6dbb597cdfa02f723753576@mail.gmail.com>
References: <53C81678.2010600@turbin.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:33758 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbaGRMAg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jul 2014 08:00:36 -0400
Received: by mail-la0-f50.google.com with SMTP id gf5so2632629lab.23
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2014 05:00:35 -0700 (PDT)
In-Reply-To: <53C81678.2010600@turbin.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Andersson <peter@turbin.se>, linux-scsi@vger.kernel.org

Peter:

We will check with Falcon MR controller and will get back to you. Can you
quickly check using stable kernel instead of upstream. (Just to check if
it is regression>) ?

~ Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Peter Andersson
> Sent: Friday, July 18, 2014 12:01 AM
> To: linux-scsi@vger.kernel.org
> Subject: megasas: failed to get PD list
>
> Hi.
> I'm having major problems with my "MegaRAID SAS 9240-81" raid
controller.
> Basically the kernel doesn't find my raid drives.
>
> Bios version: 4.38.02.0 (January 16 2014) The bios of the raid
controller shows
> a fully working (and initialized) raid 0.
>
> Kernel: 3.15.1-031501-generic (ubuntu server 14.04)
>
> This is the full dmesg regarding the card:
>
> [    0.902723] megasas: 06.803.01.00-rc1 Mon. Mar. 10 17:00:00 PDT 2014
> [    0.902788] megasas: 0x1000:0x0073:0x1000:0x9240: bus 3:slot 0:func 0
> [    0.903121] megasas: FW now in Ready state
> [    0.903180] megaraid_sas 0000:03:00.0: irq 80 for MSI/MSI-X
> [    0.903188] megaraid_sas 0000:03:00.0: [scsi0]: FW supports<0> MSIX
> vector,Online CPUs: <12>,Current MSIX <1>
> [    0.924336] megasas_init_mfi: fw_support_ieee=67108864
> [    0.924372] megasas: INIT adapter done
> [   72.855404] megasas: failed to get PD list
>
> lspci:
> 03:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 2008
> [Falcon] (rev 03)
>
> megaraidsas-status:
> -- Arrays informations --
> -- ID | Type | Size | Status
>
> -- Disks informations
> -- ID | Model | Status | Warnings
>
> After the drives are initialized i also get this message:
> Virtual drive handled by bios
>
> That's all i can think to be of interest to you.
> Could anyone give me some pointers on what could be wrong?
>
> Thanks!
>
> /Peter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
