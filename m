From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 15/15] megaraid_sas: SPERC boot driver reorder
Date: Fri, 8 Jan 2016 12:37:00 +0530
Message-ID: <667c88bca37fe6c51b8dc68a7cad498e@mail.gmail.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
 <1450445228-26571-16-git-send-email-Sumit.Saxena@avagotech.com> <20151218140510.GA6679@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34550 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbcAHHHD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2016 02:07:03 -0500
Received: by mail-lb0-f172.google.com with SMTP id cl12so2605817lbc.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jan 2016 23:07:02 -0800 (PST)
In-Reply-To: <20151218140510.GA6679@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: jbottomley@parallels.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, December 18, 2015 7:35 PM
> To: Sumit Saxena
> Cc: jbottomley@parallels.com; hch@infradead.org;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org;
> kashyap.desai@avagotech.com; Uday Lingala
> Subject: Re: [PATCH 15/15] megaraid_sas: SPERC boot driver reorder
>
> On Fri, Dec 18, 2015 at 06:57:08PM +0530, Sumit Saxena wrote:
> > This patch will add support for drive ordering for a particular set of
device ID
> (0x005D, 0x005F) & subsystem vendor ID(0x1028).
>
> This really has no business in Linux.  Everyone should be using uuid
based disk
> addressing if they care.  Tell Dell they should stop coming up with this
crap, as
> they keep leaking this weird ordering things in again and again.

This patch can be ignored. We discussed with Dell on this and they are
fine to backout the patch.
Can you provide any feedback on rest of the patches?

Thanks,
Sumit
