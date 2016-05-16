From: Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: Re: [PATCH] storvsc: use small sg_tablesize on x86
Date: Mon, 16 May 2016 16:26:33 -0400
Message-ID: <573A2CF9.5060702@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:59493 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbcEPU0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2016 16:26:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olaf@aepfle.de
Cc: KY Srinivasan <kys@microsoft.com>, James Bottomley <JBottomley@Odin.com>, Haiyang Zhang <haiyangz@microsoft.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Replying to thread:
https://lkml.org/lkml/2016/2/26/1090


> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Thursday, January 28, 2016 7:37 AM
> To: Olaf Hering <olaf@aepfle.de>
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; linux-kernel@vger.kernel.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH] storvsc: use small sg_tablesize on x86
>
> On Thu, 2016-01-28 at 07:48 +0100, Olaf Hering wrote:
> > On Wed, Jan 27, James Bottomley wrote:
> >
> > > It's not really architecture independent, is it?  Just use the bit
> > > width config.
> >
> > Again: which one? This driver is not for mips|powerpc|score|sh.
>
> zgrep CONFIG_.*BIT /proc/config.gz
> [...]
> CONFIG_64BIT=y
>
> James

    Olaf,

    Would you be resubmitting this patch?

    Thanks,

    K. Y

Hello,

It doesn't appear this patch ever landed in Mainline.  Olaf, do you have
plans to submit this patch?

Thanks,

Joe




