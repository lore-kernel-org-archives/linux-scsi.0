From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 7/11]: megaraid_sas: Add MegaRAID 9265/9285 specific functions:
 megaraid_sas_fusion.c
Date: Fri, 17 Dec 2010 11:42:39 +0100
Message-ID: <4D0B3E9F.5000101@redhat.com>
References: <AANLkTik1KwdG+73gWCqGj7sROdxWfBYfKqH4t=rcQkhi@mail.gmail.com>	<4D0A1AD0.1040703@redhat.com>	<AANLkTikEB02WAiHTYe=FLm9EKhjTdaLLd97NQvWg2Y9t@mail.gmail.com> <AANLkTin5=YL2mQxtGKQUTRCvnb2N29B32+J2ds8t-xPP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab0LQKms (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Dec 2010 05:42:48 -0500
In-Reply-To: <AANLkTin5=YL2mQxtGKQUTRCvnb2N29B32+J2ds8t-xPP@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com, James Bottomley <James.Bottomley@suse.de>

On 12/16/2010 06:13 PM, adam radford wrote:
> On Thu, Dec 16, 2010 at 8:58 AM, adam radford <aradford@gmail.com> wrote:
>   
>> On Thu, Dec 16, 2010 at 5:57 AM, Tomas Henzl <thenzl@redhat.com> wrote:
>>     
>>> Hi Adam, Bo,
>>>
>>> The function megasas_fusion_ocr_wq seems to be used already in patch 6/11
>>> and declared in 7/11 - this breaks bisectability.
>>>
>>> Further my compiler complains about a large frame size.
>>> Probably the 'struct scsi_device dev' is too large to be on stack.
>>> make checkstack
>>> ...
>>> 0x000090f4 megasas_fusion_ocr_wq [megaraid_sas]:        1696
>>>
>>>       
>> Tomas,
>>
>> Thanks, we will fix this and repost patches 6 thru 10.
>>
>> -Adam
>>
>>     
> Tomas,
>
> Actually, if you look the patch 6, we put a note in there, that
> patches 6 thru 10 must be applied 'at once' for the build to work:
>
> "Note: Patches 6 thru 10 have to be applied at once in order to build."
>   
I'm not sure if git-bisect can understand this.

> This has been allowed on this list before.  Otherwise, we would have a
> very large patch while turning on the new support for this controller,
> making the patch less review-able by the community.
>   
If the maintainer accepts this, than I'm fine too. 

> I will look into and fix the large frame size compile issue you are
> seeing and re-post the appropriate patches.
>   
Thanks.
Tomas

> -Adam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

