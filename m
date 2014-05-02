From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: Re: [PATCH v1.0 1/11] arcmsr: Revise interrupt service routine relate function
Date: Fri, 2 May 2014 17:51:48 +0800
Message-ID: <CAKiknE8ZapUdnygsAVB8rwv_HwnT-+diXVVKaNby8YCiHzYK4g@mail.gmail.com>
References: <1398850855.1769.11.camel@localhost>
	<1398876964.2182.13.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33561 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaEBJvu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2014 05:51:50 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so2053130wiv.9
        for <linux-scsi@vger.kernel.org>; Fri, 02 May 2014 02:51:49 -0700 (PDT)
In-Reply-To: <1398876964.2182.13.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>, "thenzl@redhat.com" <thenzl@redhat.com>

Hi James,

Indeed, it makes you confusion that I mistake typing the subject.
It should be [PATCH v1.0 1/16] , but not [PATCH v1.0 1/11].
Why I use v1.0 other than v1.4? Changing from 11 patches to 16 patches.
Because I spend a long time to simplify each patch, so patch number is increase.
It is easier to review.

I am so sorry for late to response that make you are inconvenient.
>From now on, I will response quickly.

Thanks for your advice.

2014-05-01 0:56 GMT+08:00 James Bottomley <jbottomley@parallels.com>:
> On Wed, 2014-04-30 at 17:40 +0800, ching wrote:
>> From: Ching<ching2048@areca.com.tw>
>>
>> Rewrite interrupt service routine relate function to fix command
>> timeout on controller very heavy loading.
>
> OK, so I think you've confused us a bit.  This looks to be an update of
> your previous v1.4 patch set, yet it's now called v1.0?
>
> Could you please include a cover letter as patch 0/x like you see
> everyone else doing on the list?  In this cover letter can you tell us
> what the disposition of the previous feedback is and what other changes
> have you done? You didn't reply to any of the comments, have have you
> fixed them?  It's very dispiriting to review 11 patches, give feedback
> and not hear anything ... and then have to review an even longer set of
> patches just to see if anything was done about your previous comments.
>
> The less interactive you are with reviews, the less chance there is that
> people will review updates ... without external reviewers, you go on a
> very long backlog of things I have to review before the patches get in.
>
> James
>
