From: "S, Venkatraman" <svenkatr@ti.com>
Subject: Re: [PATCH RESEND 3/3] drivers/scsi/ufs: fix incorrect return value
 about SUCCESS and FAILED
Date: Tue, 10 Jul 2012 20:39:16 +0530
Message-ID: <CANfBPZ_venn6QRJUZY4bAXgGrF-RPVLrv8MAMFWoUNFy_PDHaA@mail.gmail.com>
References: <1341929364-9122-1-git-send-email-svenkatr@ti.com>
 <1341929364-9122-4-git-send-email-svenkatr@ti.com> <1341931340.3021.70.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:48754 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325Ab2GJPJj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jul 2012 11:09:39 -0400
Received: by bkty15 with SMTP id y15so162634bkt.16
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jul 2012 08:09:37 -0700 (PDT)
In-Reply-To: <1341931340.3021.70.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, Namjae Jeon <linkinjeon@gmail.com>

On Tue, Jul 10, 2012 at 8:12 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2012-07-10 at 19:39 +0530, Venkatraman S wrote:
>> From: Namjae Jeon <linkinjeon@gmail.com>
>>
>> Currently the UFS host driver has returned incorrect values for SUCCESS
>> and FAILED.  Fix it to return the correct value to the upper layer.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> Acked-by: Santosh Y <santoshsy@gmail.com>
>> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> The signoff chain here doesn't make sense.  It needs to be signed off by
> you, not by Andrew since you're the one sending the patches.  Signoffs
> follow the way the patch is transmitted, so it needs author (it has)
> followed by maintainer ack (it has) followed by signoff of the person
> sending the patch to the list (that's you) which is missing.
>
Apologies - I took these patches from linux-next directly.
I'll send again with my Sign-Off.
