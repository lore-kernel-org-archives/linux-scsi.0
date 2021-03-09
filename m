Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A30C4332B
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 17:16:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D36EE64FCF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 17:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhCIRPl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 12:15:41 -0500
Received: from mail-pj1-f49.google.com ([209.85.216.49]:40742 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhCIRPd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 12:15:33 -0500
Received: by mail-pj1-f49.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so5353146pjq.5;
        Tue, 09 Mar 2021 09:15:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=alSe8NHdrm3lyNmy/FOWhW9jXK+b+/HNwLuDL+B52JU=;
        b=YIDwezu9XtZHmQ9DcunteaPnvkFQJTn3YCQsKTvjqThjy/n+3Ufk2f8qD04Ca/dTes
         UniJVV5MK4NzdhXRTPAlafrCDBnnlkRm5Z7V3ZItnToaE49oEPINLc6wlfLoyvrTU192
         FjtuDrNZIR9OHHECnFpe8ckjcCZKTWzRQGnBxrcInIrIoNQVnigoMon6x0HL/s9i3wOA
         ks6WPJwGfwKigMxe8vU1Bm/OQYDxBu+gbKLpn0pSbJBsb7tenWjl89uoCcHvrqoFjMKX
         iUzKHmW1+6kQD8IMgb2Xh7kAxpcu5UN4g8NMYvqvsDn0HVpnMQI3nV6LdyJW1lYU7T43
         sTJQ==
X-Gm-Message-State: AOAM531yhD/4tSwjy/ujvpJRNMT8bdu81bW4PCx6ZC4cOpneBDnjNkl1
        xlWTOCZz0Bn6ZGl+fudhuaw=
X-Google-Smtp-Source: ABdhPJwspxhU0wsGuv/Z/nSW5xY3iYKTZEe9ErRS+Acbysoj/VMc9gIMhnm4PGdmsOwgmoFMbvRBPw==
X-Received: by 2002:a17:902:ed41:b029:e5:c92d:ec24 with SMTP id y1-20020a170902ed41b02900e5c92dec24mr26046670plb.57.1615310132899;
        Tue, 09 Mar 2021 09:15:32 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id z2sm11232136pfq.198.2021.03.09.09.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 09:15:32 -0800 (PST)
Subject: Re: [PATCH 01/23] target/iblock: remove an extra argument
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-2-chaitanya.kulkarni@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9996fa8d-8861-0888-b9ba-d0dbac94073b@acm.org>
Date:   Tue, 9 Mar 2021 09:15:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210228055645.22253-2-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/27/21 9:56 PM, Chaitanya Kulkarni wrote:
> The twp arguments to the functions op and opf which are REQ_OP_XXX and
       ^^^

typo?

