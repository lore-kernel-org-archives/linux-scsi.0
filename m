From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 7/11]: megaraid_sas: Add MegaRAID 9265/9285 specific
 functions: megaraid_sas_fusion.c
Date: Thu, 16 Dec 2010 09:13:20 -0800
Message-ID: <AANLkTin5=YL2mQxtGKQUTRCvnb2N29B32+J2ds8t-xPP@mail.gmail.com>
References: <AANLkTik1KwdG+73gWCqGj7sROdxWfBYfKqH4t=rcQkhi@mail.gmail.com>
	<4D0A1AD0.1040703@redhat.com>
	<AANLkTikEB02WAiHTYe=FLm9EKhjTdaLLd97NQvWg2Y9t@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57578 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab0LPRNV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2010 12:13:21 -0500
Received: by iwn9 with SMTP id 9so3501249iwn.19
        for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2010 09:13:20 -0800 (PST)
In-Reply-To: <AANLkTikEB02WAiHTYe=FLm9EKhjTdaLLd97NQvWg2Y9t@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On Thu, Dec 16, 2010 at 8:58 AM, adam radford <aradford@gmail.com> wrot=
e:
> On Thu, Dec 16, 2010 at 5:57 AM, Tomas Henzl <thenzl@redhat.com> wrot=
e:
>> Hi Adam, Bo,
>>
>> The function megasas_fusion_ocr_wq seems to be used already in patch=
 6/11
>> and declared in 7/11 - this breaks bisectability.
>>
>> Further my compiler complains about a large frame size.
>> Probably the 'struct scsi_device dev' is too large to be on stack.
>> make checkstack
>> ...
>> 0x000090f4 megasas_fusion_ocr_wq [megaraid_sas]: =A0 =A0 =A0 =A01696
>>
>
> Tomas,
>
> Thanks, we will fix this and repost patches 6 thru 10.
>
> -Adam
>

Tomas,

Actually, if you look the patch 6, we put a note in there, that
patches 6 thru 10 must be applied 'at once' for the build to work:

"Note: Patches 6 thru 10 have to be applied at once in order to build."

This has been allowed on this list before.  Otherwise, we would have a
very large patch while turning on the new support for this controller,
making the patch less review-able by the community.

I will look into and fix the large frame size compile issue you are
seeing and re-post the appropriate patches.

-Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
