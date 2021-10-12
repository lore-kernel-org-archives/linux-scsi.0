Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 159CBC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2BCE60E97
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhJLXTO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:19:14 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:45738 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhJLXTN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:19:13 -0400
Received: by mail-pl1-f182.google.com with SMTP id g9so529044plo.12
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:17:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YCaotr1go426c5IVjI7aeaVAFojrJ2+TS1WChjL5Ga4=;
        b=ZuZUXSaK9MfZ2JkGDbaf6LV4YzieV2OLySsm9kgW/XpwYhHIkP57RfQ0JxU3gkgfx/
         ppo41b3HJxw/XGGX4n5hV4iFuV8GtF135w3QP3TnI8rv2LvVRRE4i/+wmK5bf8YzvBMi
         zbqAHCqU+oSKC+/1F2APO+IMNw25DyHLLiX+3oEf3iw7HrRdlxLMMEm8dBQR23Vnk5w8
         KdyY/CwaY6ygtahhTbI29GhB95pR2lsqfgXS7w0ujFs/aYonI3NQ7UXu3qZlkTCz+wqN
         AeRLzldukgaXAlPPDf5wTHuBLcupJXYMImOc35/266OLjVTLdWms4aDI0y9UjSmq5Eqb
         tddQ==
X-Gm-Message-State: AOAM531qmbj/6hJMnG0Lx8vwKZe4nMZ2ZwiO76tlqJLBMErMTdTOq2+8
        Nw1zMtn8aB8JkxC91okcwg/j4a4HAgw=
X-Google-Smtp-Source: ABdhPJz5UyDtCAyg8ZM84gLzB4oHj/b+sa3lSv83Ai5YTKX8DhZZg+dtaPgXS9uY0hkRC6AHRKf5Xw==
X-Received: by 2002:a17:90b:4c0f:: with SMTP id na15mr9522689pjb.200.1634080631002;
        Tue, 12 Oct 2021 16:17:11 -0700 (PDT)
Received: from ?IPv6:2620:0:1000:2514:b4a0:9c51:a53e:4ea4? ([2620:0:1000:2514:b4a0:9c51:a53e:4ea4])
        by smtp.gmail.com with ESMTPSA id e9sm4149664pjl.41.2021.10.12.16.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 16:17:10 -0700 (PDT)
Subject: Re: Meeting about the UFS driver
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <4942b187-f6ab-e93f-604b-df635043c2bb@acm.org>
 <6c9f6faf1e4a3dddbd4276402cb38318a99b6026.camel@HansenPartnership.com>
 <bb051910-43cd-9007-9267-3579765137cb@acm.org> <YWYTPnEBGatnfmO4@mit.edu>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f9144121-9f54-735c-c00b-f05c25e8c74a@acm.org>
Date:   Tue, 12 Oct 2021 16:17:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YWYTPnEBGatnfmO4@mit.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/12/21 3:59 PM, Theodore Ts'o wrote:
> On Tue, Oct 12, 2021 at 11:05:55AM -0700, Bart Van Assche wrote:
>> That document has been created using my work account. Recently my employer
>> changed the settings for work documents such that even read-only access has
>> to be granted explicitly. Making a document viewable without authentication
>> is no longer supported. I am considering next time I use Google Docs to
>> prepare a meeting to use my personal gmail account since making documents
>> public from a personal account is still supported.
> 
> Yeah, that would be my strong recommendation.  My employer has the
> same restriction and I similarly will make sure that I create such
> documents using my personal gmail account and then share Editor status
> with my work account so I can more easily edit it from my work account
> if necessary.
> 
> If you have a document that was created with your work account, the
> procedure to "transfer" it over to your personal account is:
> 
> * If necessary, remove any work-proprietary information from the
>    document; you can revert that change at the end of this procedure
>    if you want the work version of the document to have internal
>    information in it
> * share the document with your personal account
> * open the document with your personal account
> * select File->Make a copy to make a copy of that document
>    which is owned by your personal account
> * Rename the copy so that it has something thing like (PUBLIC)
>    in the the name so you can easily disambiguate the public
>    version from the work version.
>    OR, delete the work version of the document so you don't end
>    up confusing yourself.
> * Enable link sharing on the public version of the document
> 
> If you've ever wondered why the document which you can reach via the
> URL https://thunk.org/gce-xfstests has "(public)" in the title, that's
> why....
> 
> It's a bit more work for you, but it makes much life much easier for
> everyone else trying to access the document.

Thanks Ted, that's very helpful! I have followed the above procedure. A version
that can be viewed without Google account is available here:
https://docs.google.com/document/d/1WqxN5fK3NfKtmtvUv8jlCteJqZ5rlNq5tz_Q9tzPozY/

Bart.
