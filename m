From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: ahc1542 fun
Date: Thu, 27 May 2004 13:30:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B625CC.1060906@pobox.com>
References: <40B401AE.9060707@pobox.com> <20040526064430.GA21531@infradead.org> <20040526175217.GU29154@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:46044 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264894AbUE0RbH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 13:31:07 -0400
In-Reply-To: <20040526175217.GU29154@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: hch@infradead.org, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

Matthew Wilcox wrote:
> On Wed, May 26, 2004 at 02:44:30AM -0400, hch@infradead.org wrote:
> 
>>This needs fixing in mca.h and mca-legacy.h.  The debian kernel package
>>has a fix that I don't quite like.  I'll rework it in the next days and
>>submit it.
> 
> 
> What I have in the PA tree is:
> 
> Index: include/linux/mca.h
> ===================================================================
> RCS file: /var/cvs/linux-2.6/include/linux/mca.h,v
> retrieving revision 1.4.46.1
> retrieving revision 1.4
> diff -u -p -r1.4.46.1 -r1.4
> --- include/linux/mca.h 23 May 2004 23:31:15 -0000      1.4.46.1
> +++ include/linux/mca.h 8 Oct 2003 20:53:03 -0000       1.4
> @@ -12,7 +12,9 @@
>  #include <linux/device.h>
>  
>  /* get the platform specific defines */
> +#ifdef CONFIG_MCA
>  #include <asm/mca.h>
> +#endif


This patch is fine with me...  If Christoph's rework will take more than 
five minutes, please (Andrew?) apply this patch.

	Jeff


