From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [Open-FCoE] [PATCH] libfc: add stats info against memory leakage
 in exchange pool
Date: Thu, 28 Oct 2010 21:53:19 +0800
Message-ID: <AANLkTikexTHUTLk9Evu-H=Lvaf_YTQXTCW+aDTJXRR30@mail.gmail.com>
References: <AANLkTimzeO6Hou9ob4Z79twUY8RjwH6NP6ndKmoOUrEH@mail.gmail.com>
	<AANLkTi=QbmJM7qCFnAvdVXcE=4sprA7MtMzMLvHvtxmd@mail.gmail.com>
	<1288226982.1431.19.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40207 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab0J1NxV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 09:53:21 -0400
Received: by wwi18 with SMTP id 18so2906900wwi.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 06:53:20 -0700 (PDT)
In-Reply-To: <1288226982.1431.19.camel@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Thu, Oct 28, 2010 at 8:49 AM, Robert Love <robert.w.love@intel.com> wrote:
> On Tue, 2010-10-26 at 21:24 +0800, Hillf Danton wrote:
>> This is the second version, with a fault in the previous version fixed.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>
> This patch fails to apply on top of your other patch that adds a
> exchange cache. I have fixed it locally and will add the fixed patch to
> fcoe-next. You also omitted any patch description in this patch other
> than it being the second version.

The related patches were prepared without consideration of each other,
and it is my fault.

>
> Can you please add more verbose descriptions to your patches. The best
> advice given to me was to have a problem statement, a statement on what
> the solution is and then any technical details. I realize that some of

I will try as hard as I can for better patch, thanks. //Hillf

> your patches are very straight-forward and don't require that degree of
> detail, but some have been a bit more involved and "seems like there is
> a problem" doesn't give much context before looking at the changes
> themselves. It would help me when reviewing your changes.
>
> Thanks, //Rob
>
>
