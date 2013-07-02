From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: Linux boot Support for 4KB sector drives ?
Date: Tue, 02 Jul 2013 14:14:10 +0200
Message-ID: <51D2C412.7090006@gmail.com>
References: <340C71CD25A7EB49BFA81AE8C83926671C6E3111@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <72590A5E6725454E9DD04F4C119FC007BC061E@bby1exm14.pmc_nt.nt.pmc-sierra.bc.ca> <51D29634.1020600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:55221 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3GBMOE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jul 2013 08:14:04 -0400
Received: by mail-bk0-f42.google.com with SMTP id jk13so2281388bkc.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jul 2013 05:14:01 -0700 (PDT)
In-Reply-To: <51D29634.1020600@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Kishore Babu Lukka <Kishore.BabuLukka@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, Tony Ruiz <Tony.Ruiz@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Asha P <Asha.P@pmcs.com>

On 07/02/2013 10:58 AM, Aaron Lu wrote:
> On 07/02/2013 03:11 PM, Kishore Babu Lukka wrote:
>> Adding Asha also.
>>
>> -----Original Message-----
>> From: Mahesh Rajashekhara 
>> Sent: Monday, July 01, 2013 11:41 AM
>> To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
>> Cc: Tony Ruiz; Achim Leubner; Mahesh Rajashekhara; Kishore Babu Lukka
>> Subject: Linux boot Support for 4KB sector drives ?
>>
>> Hello,
>>
>> Does any of the Linux OS flavors support booting from the 4K sector
>> (advanced format) drive  in legacy BIOS mode (MBR partitioning scheme) ?
> 
> That depends on boot loader, not Linux I think.
> Linux has support for 4k sector drive, but if the boot loader
> doesn't, it can't fetch the kernel into memory and load Linux.
> 
> Legacy grub makes use of BIOS interrupt service and thus shouldn't
> be able to support 4k sector drive, I don't know the status of grub2.
> 
> Thanks,
> Aaron
> 
>>
>> Thanks & Regards,
>> Mahesh
Hello,

It also depends on HBA BIOS driver, which need to properly handle 4k
sector. Linux kernel do support 4k sector.

Regards,
Jack


