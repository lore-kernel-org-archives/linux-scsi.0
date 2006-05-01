From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] fusion - race between mptfc_register_dev and  mptfc_target_alloc
Date: Mon, 1 May 2006 12:10:43 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D700C6921@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:54464 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750789AbWEASKw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 May 2006 14:10:52 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mdr@sgi.com, linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, jeremy@sgi.com, gwh@sgi.com

On Monday, May 01, 2006 12:07 PM, Micheal Reed wrote: 

> 
> 
> This patch applies to 2.6.17-rc3 after applying these patches from
> scsi-rc-fixes-2.6.git.
> 
>    [SCSI] mptfusion: bug fix's for raid components adding/deleting
>    [SCSI] - fusion - mptfc bug fix's to prevent deadlock situations
>    [SCSI] fusion - bug fix stack overflow in mptbase
> 

These three patchs are there in James Bottomley's rc-fixes-2.6 tree.

http://www.kernel.org/pub/linux/kernel/people/jejb/scsi-rc-fixes-2.6.dif
f

Eric

