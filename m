From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH resend 2/2] mpt3sas: Remove unnecessary synchronize_irq()
 before free_irq()
Date: Wed, 9 Mar 2016 18:56:08 +0530
Message-ID: <CAK=zhgoaA2gZYtjXJ+Gebi7Kn9-JX+PccPNLMnrvC56R4xV0OA@mail.gmail.com>
References: <1457086507-5937-1-git-send-email-lars@metafoo.de>
	<1457086507-5937-2-git-send-email-lars@metafoo.de>
	<yq1si00wh6u.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36251 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbcCIN0K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2016 08:26:10 -0500
Received: by mail-ob0-f172.google.com with SMTP id m7so46002692obh.3
        for <linux-scsi@vger.kernel.org>; Wed, 09 Mar 2016 05:26:09 -0800 (PST)
In-Reply-To: <yq1si00wh6u.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, "James E.J. Bottomley" <JBottomley@odin.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, MPT-FusionLinux.pdl@broadcom.com

On Wed, Mar 9, 2016 at 7:22 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Lars-Peter" == Lars-Peter Clausen <lars@metafoo.de> writes:
>
> Lars-Peter> Calling synchronize_irq() right before free_irq() is quite
> Lars-Peter> useless. On one hand the IRQ can easily fire again before
> Lars-Peter> free_irq() is entered, on the other hand free_irq() itself
> Lars-Peter> calls synchronize_irq() internally (in a race condition free
> Lars-Peter> way), before any state associated with the IRQ is freed.
>
> Broadcom folks, please review.

Martin,

Please consider this patch as Ack-by: Sreekanth Reddy
<sreekanth.reddy@broadcom.com>

Thanks,
Sreekanth

>
> --
> Martin K. Petersen      Oracle Linux Engineering
