From: "IpsLinux" <ipslinux@Adaptec.com>
Subject: RE: ips.c warnings
Date: Thu, 20 Oct 2005 13:59:18 -0400
Message-ID: <A121ABA5B472B74EB59076B8E3C8F0190195F844@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:22464 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932069AbVJTR7U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 13:59:20 -0400
Content-Class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Salyzyn, Mark" <mark_salyzyn@Adaptec.com>
Cc: IpsLinux <ipslinux@Adaptec.com>, Matthew Wilcox <matthew@wil.cx>, akmpm@osdl.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org


OK, I'm convinced. I will re-do the ips patch, eliminate the error
checking, and use kmap_atomic().

The patch should be small, but since this is in the main I/O path, the
skeptic in me says to stress the changes I make thoroughly under both
the 2.4 and 2.6 kernels. So it may be a couple days before I post an
updated patch.

 

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Thursday, October 20, 2005 1:40 PM
To: Salyzyn, Mark
Cc: IpsLinux; Christoph Hellwig; Matthew Wilcox; akmpm@osdl.org;
James.Bottomley@steeleye.com; linux-scsi@vger.kernel.org
Subject: Re: ips.c warnings

On Thu, Oct 20, 2005 at 01:38:30PM -0400, Salyzyn, Mark wrote:
> Jack, do not forget legacy kernels. Christoph is notorious for dealing

> only with latest kernel only.
> 
> Christoph, has this always been true? I believe it to be, but just in 
> case ...

For mainline this was always true.  OTOH Adaptec is notorious for
supporting very odd non-standard kernels, so who knows ;-)



