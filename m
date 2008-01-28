From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: RE: Patch added to scsi-misc-2.6:  [SCSI] aacraid: fib context lock
 for management ioctls
Date: Mon, 28 Jan 2008 10:01:07 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F4395CF301@ADPE2K703.adaptec.com>
References: <200801251705.m0PH5P9G011887@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:47533 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYA1SBN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jan 2008 13:01:13 -0500
In-Reply-To: <200801251705.m0PH5P9G011887@hera.kernel.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <jejb@kernel.org>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Merde, this patch caused a problem with a system lockup. Please revert it.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: James Bottomley [mailto:jejb@kernel.org]
> Sent: Friday, January 25, 2008 12:05 PM
> To: Salyzyn@hera.kernel.org; Salyzyn, Mark; James Bottomley; AACRAID
> Subject: Patch added to scsi-misc-2.6: [SCSI] aacraid: fib
> context lock for management ioctls
>
> Your commit:
>
>     [SCSI] aacraid: fib context lock for management ioctls
>
>     Alan noticed the lack of locking surrounding the driver's dealings
>     with the fib context managed by the trio of ioctls that
> are used by
>     the RAID management applications to retrieve Adapter
> Initiated FIBs. I
>     merely expanded the fib lock to include the fib context.
> There have
>     been no field reports of any issues generally because the
> applications
>     are relatively static and do not come and go often enough
> to stress
>     this area. I bloated this patch a little with some space junk.
>
>     Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
>     Signed-off-by: James Bottomley
> <James.Bottomley@HansenPartnership.com>
>
> has been added to the upstream SCSI tree
> You can find it here:
>
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.g
> it;a=commit;h=a119ee8ee3045bf559d4cf02d72b112f3de2a15b
>
> This patch is scheduled to be pushed when the merge window
> opens for 2.6.25
>
> James Bottomley
>
> P.S. If you find this email unwanted, set up a procmail rule
> junking on
> the header:
>
> X-Git-Tree: SCSI
>
