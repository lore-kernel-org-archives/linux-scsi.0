From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] aacraid changes for 2.4.24 kernel to add support of A
	MD64 (part 2)
Date: Fri, 13 Feb 2004 18:14:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703EF917E@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:27603 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S267310AbUBMXOj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 18:14:39 -0500
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Friday, February 13, 2004 3:38 PM, Salyzyn, Mark wrote
> 
> +#if (defined(__x86_64__))
> +# include <asm-x86_64/ioctl32.h>
> +  /* Cast the function, since sys_ioctl does not match */
> +# define aac_ioctl32(x,y) register_ioctl32_conversion((x), \
> +    (int(*)(unsigned int,unsigned int,unsigned long,struct 
> file*))(y))
> +# include <asm/uaccess.h>
> +#endif
> 
> 	So why do the other drivers not need this?
> 
> [MGS] Not sure what you mean about other drivers? I have a series of
> warning messages without the cast.
> 
> Or do you mean the arrangements for 
> register_ioctl32_conversion? Because
> other drivers do not have 32 bit applications calling a 64 
> bit ioctl for
> RAID management functions. The current structure of the x86_64 port in
> the 2.4 tree is to block 32 bit applications from calling the ioctl
> without these arrangements.
> 


See the patch I just posted about an hour back.
This code is here most likely for the same customer.


Eric Moore
Staff Engineer
Standard Storage Products Division
LSI Logic Corporation
4420 Arrowswest Drive
Colorado Springs, CO 80907
Email: emoore@lsil.com
Web: http://www.lsilogic.com/
