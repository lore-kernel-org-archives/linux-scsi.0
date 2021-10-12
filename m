Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9CFC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 18:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 524CE610CC
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 18:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhJLSIc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 14:08:32 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:43799 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbhJLSIA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 14:08:00 -0400
Received: by mail-pl1-f172.google.com with SMTP id y1so80842plk.10
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 11:05:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LaxMRGRNyphKcVfCZF2lH4udrVfv3dwlvUXLK1SNiro=;
        b=ll95Dujg79VS8v7dNWUnCWbxNnQ6G6AyhaIK6RdPaX0zyrbsmhefZ8Z5pAaMks8l/7
         tpsoltMokwwBYS3cF4D7U064MgI9x7muhp9iaA+t7qUdtlDoLHCnwwE9JPk5Zc3wymc2
         af38ZHxSTPboNh+S+v/XNLhHTVIDfR2/nP60mRuRK8KLe99ReOvHgT5LibK+EPylhizh
         dY96SyP8OADiIDYZJrfIvQZKxyjA59x+HEY2T/U8qdewp6vbn82lmS5cILSYcgCwYi7g
         OzGB5bXhV3JuFH2HPSWxMNHKYXpEiWyFO5el0lSl74sFuLS48DOYygQ/cY9fr/rDCPBk
         wuCA==
X-Gm-Message-State: AOAM5304KNHRKBhItZmq1yZUKyA8Hj15Pp+X8IG52RPKPUu4X8GP03C8
        ExOOyWxLvIpLBVEiJczCAAPvA70YBco=
X-Google-Smtp-Source: ABdhPJyfgu4LJPa67lt0XFBr/Z5E2N7pJPTfiCifHwpB3Nd6LxtN3PIGj+Zw3vvZ0uEntzq9Izwb0g==
X-Received: by 2002:a17:90a:16:: with SMTP id 22mr7917136pja.25.1634061957643;
        Tue, 12 Oct 2021 11:05:57 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id z24sm4086872pfr.141.2021.10.12.11.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 11:05:57 -0700 (PDT)
Subject: Re: Meeting about the UFS driver
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>
References: <4942b187-f6ab-e93f-604b-df635043c2bb@acm.org>
 <6c9f6faf1e4a3dddbd4276402cb38318a99b6026.camel@HansenPartnership.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <bb051910-43cd-9007-9267-3579765137cb@acm.org>
Date:   Tue, 12 Oct 2021 11:05:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <6c9f6faf1e4a3dddbd4276402cb38318a99b6026.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/12/21 10:42 AM, James Bottomley wrote:
> On Tue, 2021-10-12 at 10:29 -0700, Bart Van Assche wrote:
>> A meeting will be held later this month to talk about the technical
>> aspects of the UFS driver and also about how to evolve the UFS
>> driver further. Since using email to coordinate a date, time and
>> agenda is inconvenient, please use the following document to reach
>> agreement about the time of the meeting and also about the agenda:
>>
>> https://docs.google.com/document/d/1pYONI__pbNcVVQqPA7iSbeQRyf0IQOuZlYR7Gnrikco/
> 
> That link is giving permission denied.  You need to update the sharing
> settings to give you an access link for anyone to view.

Hi James,

That document has been created using my work account. Recently my 
employer changed the settings for work documents such that even 
read-only access has to be granted explicitly. Making a document 
viewable without authentication is no longer supported. I am considering 
next time I use Google Docs to prepare a meeting to use my personal 
gmail account since making documents public from a personal account is 
still supported.

The procedure to get access to this document is as follows:
* Log in to an account with which a Google password has been associated.
* Open the above link. The following text will appear: "You need access.
Ask for access, or switch to an account with access. Learn more. 
[Request access]".
* Select the [Request access] button.

The contents of that document so far is as follows:
* Proposed date and time of the meeting.
* Draft agenda. So far there is one item on the agenda, namely how to 
implement multiqueue support in the UFS driver without triggering lock 
contention between submitters.

PS: meeting about the UFS driver was suggested by another UFS driver 
contributor. I try to minimize the number of meetings on my calendar.

Bart.
