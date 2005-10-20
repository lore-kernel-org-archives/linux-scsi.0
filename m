From: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Subject: RE: ips.c warnings
Date: Thu, 20 Oct 2005 13:25:28 -0400
Message-ID: <A121ABA5B472B74EB59076B8E3C8F0190195F824@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:33719 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932428AbVJTRZ3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 13:25:29 -0400
Content-Class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: akmpm@osdl.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, IpsLinux <ipslinux@adaptec.com>


I have no problem trying kmap_atomic() as long as there's a sound,
technical reason for changing code that's worked well for years.

What are the advantages/reasons of changing to use kmap_atomic() ?   It
appears very few SCSI drivers use it.


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Matthew Wilcox
Sent: Thursday, October 20, 2005 1:06 PM
To: Hammer, Jack
Cc: akmpm@osdl.org; James.Bottomley@steeleye.com;
linux-scsi@vger.kernel.org; IpsLinux
Subject: Re: ips.c warnings

On Thu, Oct 20, 2005 at 12:59:54PM -0400, Jack Hammer wrote:
> I did not use kmap() because these routines can be called from the
interrupt handler context and kmap() can sleep.

Is there a reason you can't use kmap_atomic() then?
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html

