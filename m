From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 16/20] [SCSI] mpt3sas: Added support for customer specific branding
Date: Thu, 25 Jun 2015 19:10:36 +0530
Message-ID: <CAK=zhgpxe-hzfe2ctjkwWsRgEYptj9pQPRO35MSq1P=cTLKjpA@mail.gmail.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-17-git-send-email-Sreekanth.Reddy@avagotech.com>
	<yq1k2uza0n5.fsf@sermon.lab.mkp.net>
	<CAK=zhgoY6s1hVzWnPKTf0iMKoFJeJ+D6xcXFAf1mQLAHMSiZ4g@mail.gmail.com>
	<yq1egl37a5u.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36336 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbFYNki (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2015 09:40:38 -0400
Received: by wicnd19 with SMTP id nd19so164477378wic.1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2015 06:40:36 -0700 (PDT)
In-Reply-To: <yq1egl37a5u.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, Jun 23, 2015 at 2:06 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> >>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:
>
> Sreekanth> I agree with you that these changes belong in pci.ids. But
> Sreekanth> Customers are asking us to print the HBA branding name while
> Sreekanth> loading the driver on their custom HBA's.
>
> Yes, and other HBA vendors have done the same (although thankfully this
> practice appears to be going out of fashion).
>
> Personally, I find SAS2308 orders of magnitude more useful and helpful
> than WHIZ-BANG2010 since the former tells me exactly what chip I'm
> dealing with.
>
> Anyway. No big deal. I just think it's a bad habit to use the kernel for
> marketing purposes.

Agreed. Can you please consider this patch for this time. Next time
onwards we take some actions to not encourage these types of request
from customers.

>
>
> --
> Martin K. Petersen      Oracle Linux Engineering




-- 

Regards,
Sreekanth
