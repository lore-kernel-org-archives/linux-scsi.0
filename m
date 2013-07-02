From: Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: Linux boot Support for 4KB sector drives ?
Date: Tue, 02 Jul 2013 16:58:28 +0800
Message-ID: <51D29634.1020600@gmail.com>
References: <340C71CD25A7EB49BFA81AE8C83926671C6E3111@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <72590A5E6725454E9DD04F4C119FC007BC061E@bby1exm14.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:48162 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab3GBI56 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jul 2013 04:57:58 -0400
Received: by mail-pa0-f44.google.com with SMTP id lj1so6006098pab.3
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jul 2013 01:57:57 -0700 (PDT)
In-Reply-To: <72590A5E6725454E9DD04F4C119FC007BC061E@bby1exm14.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kishore Babu Lukka <Kishore.BabuLukka@pmcs.com>
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, Tony Ruiz <Tony.Ruiz@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Asha P <Asha.P@pmcs.com>

On 07/02/2013 03:11 PM, Kishore Babu Lukka wrote:
> Adding Asha also.
> 
> -----Original Message-----
> From: Mahesh Rajashekhara 
> Sent: Monday, July 01, 2013 11:41 AM
> To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
> Cc: Tony Ruiz; Achim Leubner; Mahesh Rajashekhara; Kishore Babu Lukka
> Subject: Linux boot Support for 4KB sector drives ?
> 
> Hello,
> 
> Does any of the Linux OS flavors support booting from the 4K sector
> (advanced format) drive  in legacy BIOS mode (MBR partitioning scheme) ?

That depends on boot loader, not Linux I think.
Linux has support for 4k sector drive, but if the boot loader
doesn't, it can't fetch the kernel into memory and load Linux.

Legacy grub makes use of BIOS interrupt service and thus shouldn't
be able to support 4k sector drive, I don't know the status of grub2.

Thanks,
Aaron

> 
> Thanks & Regards,
> Mahesh
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

