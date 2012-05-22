From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH] [SCSI] ufs: fix potential NULL pointer dereferencing
 error in ufshcd_probe.
Date: Wed, 23 May 2012 08:03:22 +0900
Message-ID: <CAKYAXd8tBD945nE1awRcVFhUtRr2=-axN-1XVMeoG7qqTmq87A@mail.gmail.com>
References: <1337610936-2757-1-git-send-email-linkinjeon@gmail.com>
	<20120522131535.22992314.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59086 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2EVXDY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2012 19:03:24 -0400
Received: by wgbdr13 with SMTP id dr13so6534513wgb.1
        for <linux-scsi@vger.kernel.org>; Tue, 22 May 2012 16:03:23 -0700 (PDT)
In-Reply-To: <20120522131535.22992314.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: santoshsy@gmail.com, vinholikatti@gmail.com, santosh.sy@samsung.com, James.Bottomley@hansenpartnership.com, jBottomley@parallels.com, linux-scsi@vger.kernel.org

Hi. Andrew.

I will do it next time.

Thanks for your advice.

2012/5/23, Andrew Morton <akpm@linux-foundation.org>:
> On Mon, 21 May 2012 10:35:36 -0400
> Namjae Jeon <linkinjeon@gmail.com> wrote:
>
>> Subject: [PATCH] [SCSI] ufs: fix potential NULL pointer dereferencing
>> error in ufshcd_probe.
>
> Nit: conventionally, the text inside [] is to be discarded by the patch
> recipient, so the title of this patch is
>
> 	ufs: fix potential NULL pointer dereferencing error in ufshcd_probe.
>
> which makes it look like a patch against fs/ufs/!
>
> There is a fashion lately of people prefixing patch titles along the
> lines of
>
>   scsi: ufs: fix potential NULL pointer dereferencing error in
> ufshcd_probe.
>
> or even
>
>   drivers: scsi: ufs: fix potential NULL pointer dereferencing error in
> ufshcd_probe.
>
> that's nuts, and I regularly turn this into a proper pathname - why
> not?
>
>   drivers/scsi/ufs: fix potential NULL pointer dereferencing error in
> ufshcd_probe.
>
>
> I'll stop now :)
>
