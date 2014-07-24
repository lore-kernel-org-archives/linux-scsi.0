From: Peter Andersson <peter@turbin.se>
Subject: Re: megasas: failed to get PD list
Date: Thu, 24 Jul 2014 09:52:42 +0200
Message-ID: <53D0BB4A.3060606@turbin.se>
References: <53C81678.2010600@turbin.se> <4f971f88b6dbb597cdfa02f723753576@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:55370 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934203AbaGXHwx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2014 03:52:53 -0400
Received: by mail-la0-f41.google.com with SMTP id s18so1635543lam.28
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2014 00:52:51 -0700 (PDT)
In-Reply-To: <4f971f88b6dbb597cdfa02f723753576@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, linux-scsi@vger.kernel.org

So, I'm replying to my own question here. In case someone else 
experiences the same problems as I did.

After I finally got in contact with LSI support it turns out that the 
9240 cards don't support newer motherboards. (I'm not sure what the 
definition of "newer" is in this case.)
Apparently the card relies on the motherboard to keep track of the 
different raids and disks and newer motherboards isn't capable of doing 
this (for some reason).
In short, there is no solution to this problem and the support tech at 
LSI suggested that I should buy another card.

Hope this helps someone.

/Peter

Kashyap Desai skrev 2014-07-18 13:54:
> Peter:
>
> We will check with Falcon MR controller and will get back to you. Can you
> quickly check using stable kernel instead of upstream. (Just to check if
> it is regression>) ?
>
> ~ Kashyap
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Peter Andersson
>> Sent: Friday, July 18, 2014 12:01 AM
>> To: linux-scsi@vger.kernel.org
>> Subject: megasas: failed to get PD list
>>
>> Hi.
>> I'm having major problems with my "MegaRAID SAS 9240-81" raid
> controller.
>> Basically the kernel doesn't find my raid drives.
>>
>> Bios version: 4.38.02.0 (January 16 2014) The bios of the raid
> controller shows
>> a fully working (and initialized) raid 0.
>>
>> Kernel: 3.15.1-031501-generic (ubuntu server 14.04)
>>
>> This is the full dmesg regarding the card:
>>
>> [    0.902723] megasas: 06.803.01.00-rc1 Mon. Mar. 10 17:00:00 PDT 2014
>> [    0.902788] megasas: 0x1000:0x0073:0x1000:0x9240: bus 3:slot 0:func 0
>> [    0.903121] megasas: FW now in Ready state
>> [    0.903180] megaraid_sas 0000:03:00.0: irq 80 for MSI/MSI-X
>> [    0.903188] megaraid_sas 0000:03:00.0: [scsi0]: FW supports<0> MSIX
>> vector,Online CPUs: <12>,Current MSIX <1>
>> [    0.924336] megasas_init_mfi: fw_support_ieee=67108864
>> [    0.924372] megasas: INIT adapter done
>> [   72.855404] megasas: failed to get PD list
>>
>> lspci:
>> 03:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 2008
>> [Falcon] (rev 03)
>>
>> megaraidsas-status:
>> -- Arrays informations --
>> -- ID | Type | Size | Status
>>
>> -- Disks informations
>> -- ID | Model | Status | Warnings
>>
>> After the drives are initialized i also get this message:
>> Virtual drive handled by bios
>>
>> That's all i can think to be of interest to you.
>> Could anyone give me some pointers on what could be wrong?
>>
>> Thanks!
>>
>> /Peter
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the
>> body of a message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html

