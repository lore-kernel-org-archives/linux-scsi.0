From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: 2.6.8-rc3: MPT Fusion compile error with PROC_FS=n
Date: Tue, 10 Aug 2004 11:42:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5704DE6124@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:6899 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S267468AbUHJPuU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2004 11:50:20 -0400
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>, Linus Torvalds <torvalds@osdl.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Here is a patch to fix this reported bug, as well a misc fix's and
enhancements highlighted in release notes found at this URL:

ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-kernel/3.01.15/

This patch is made against the 3.01.09 driver.
Also - this driver has just completed testing in the LSI labs.


Eric Moore
LSI Logic



On Friday, August 06, 2004 1:58 PM, Adrian Bunk wrote:
> 
> The "MPT Fusion driver 3.01.09 update" in 2.6.8-rc causes the 
> following 
> compile error with CONFIG_PROC_FS=n:
> 
> <--  snip  -->
> 
> ...
>   CC [M]  drivers/message/fusion/mptbase.o
> drivers/message/fusion/mptbase.c: In function `mptbase_probe':
> drivers/message/fusion/mptbase.c:1394: `procmpt_iocinfo_read' 
> undeclared 
> (first use in this function)
> drivers/message/fusion/mptbase.c:1394: (Each undeclared identifier is 
> reported only once
> drivers/message/fusion/mptbase.c:1394: for each function it 
> appears in.)
> drivers/message/fusion/mptbase.c:1399: `procmpt_summary_read' 
> undeclared 
> (first use in this function)
> drivers/message/fusion/mptbase.c: In function `mpt_do_ioc_recovery':
> drivers/message/fusion/mptbase.c:1626: warning: `r' might be used 
> uninitialized in this function
> drivers/message/fusion/mptbase.c: In function `GetIocFacts':
> drivers/message/fusion/mptbase.c:2419: warning: unknown 
> conversion type 
> character `z' in format
> drivers/message/fusion/mptbase.c:2419: warning: too many 
> arguments for 
> format
> make[3]: *** [drivers/message/fusion/mptbase.o] Error 1
> 
> <--  snip  -->
> 
> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
