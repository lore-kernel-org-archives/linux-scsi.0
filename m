From: "Miller, Mike (OS Dev)" <mike.miller@hp.com>
Subject: RE: [PATCH 2.6] cciss typo fix
Date: Fri, 7 Jan 2005 17:24:21 -0600
Message-ID: <D4CFB69C345C394284E4B78B876C1CF107DC0185@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ztxmail03.ztx.compaq.com ([161.114.1.207]:47120 "EHLO
	ztxmail03.ztx.compaq.com") by vger.kernel.org with ESMTP
	id S261736AbVAGXY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2005 18:24:29 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, Jens Axboe <axboe@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> 
> 
> On Fri, 2005-01-07 at 17:01 -0600, mike.miller@hp.com wrote:
> > -		*total_size = be32_to_cpu(*((__be32 *) 
> &buf->total_size[0]))+1;
> > -		*block_size = be32_to_cpu(*((__be32 *) 
> &buf->block_size[0]));
> > +		*total_size = be32_to_cpu(*((__u32 *) 
> &buf->total_size[0]))+1;
> > +		*block_size = be32_to_cpu(*((__u32 *) 
> &buf->block_size[0]));
> 
> I don't think that's a typo.  It was introduced by this patch:
> 
> ChangeSet 1.1988.24.79 2004/10/06 07:55:02 viro@www.linux.org.uk
>   [PATCH] cciss endianness and iomem annotations
>  
> The idea being that BE and LE numbers should be annotated differently,
> so the __be32 annotations look correct to me.  I think sparse 
> will warn
> if you make this change.

Hmmm, SuSE complained that __be32 was not defined in the kernel. Any other thoughts, anyone?

mikem
