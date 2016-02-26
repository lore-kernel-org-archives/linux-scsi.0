From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 2/2] sd: disable write same for SAT as per the comment
Date: Sat, 27 Feb 2016 05:07:18 +0800
Message-ID: <CAGnHSE=U88=B2KGAAe0V_7S=gs=H+dZ9WSicsxCZpQj0mfE=RQ@mail.gmail.com>
References: <56d0b08c.e99c420a.dbca1.0415@mx.google.com>
	<1456517794.2369.43.camel@HansenPartnership.com>
	<CAGnHSE=8d2=b3nN=0f14t_5Nf_GLsb0HXYeajZtz5As8SophsA@mail.gmail.com>
	<1456520250.2369.45.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:34120 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbcBZVHT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2016 16:07:19 -0500
Received: by mail-yw0-f193.google.com with SMTP id f6so4762757ywa.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Feb 2016 13:07:19 -0800 (PST)
In-Reply-To: <1456520250.2369.45.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

No I mean I no longer thinks that this condition needs to be inverted.
I just THOUGHT that !scsi_get_vpd_page is true if it DIDN'T get the
page.

On 27 February 2016 at 04:57, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Sat, 2016-02-27 at 04:32 +0800, Tom Yan wrote:
>> Oh I made a mistake on this one then.
>>
>> Since I send it with another patch, should I resend that alone?
>
> Yes, that's fine. but you need to explain as part of the changelog why
> this condition needs inverting because your Subject just says "as per
> the comment" which makes no sense if you're changing the comment.
>
> James
>
>
