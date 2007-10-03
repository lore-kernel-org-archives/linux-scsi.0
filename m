From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 21/21] advansys: Changes to work on parisc
Date: Tue, 02 Oct 2007 22:00:18 -0400
Message-ID: <4702F7B2.7080600@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765432770-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:54694 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbXJCCAV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 22:00:21 -0400
In-Reply-To: <11913765432770-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 8e39df5..bc0f2e5 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -120,7 +120,7 @@ typedef unsigned char uchar;
>  #define CC_VERY_LONG_SG_LIST 0
>  #define ASC_SRB2SCSIQ(srb_ptr)  (srb_ptr)
>  
> -#define PortAddr                 unsigned short	/* port address size  */
> +#define PortAddr                 unsigned int	/* port address size  */
>  #define inp(port)                inb(port)
>  #define outp(port, byte)         outb((byte), (port))

everybody just uses unsigned long these days...  any reason using 
unsigned long would be harmful?

