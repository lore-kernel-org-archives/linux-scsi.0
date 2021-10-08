Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FABC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC1BE61019
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhJHUVq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:21:46 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:44592 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbhJHUVq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:21:46 -0400
Received: by mail-pl1-f180.google.com with SMTP id t11so6830651plq.11
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:19:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WNQwqEK/T7l1P/BmQLC5JUCVwG0xd2VyMp0bR8UBOqA=;
        b=Sp/jh/Z8idYkBwzkziNTkbqVmCvyJUm1PJdRP8erK452uiYaTZq9nuZDn/AKMvhmnN
         aXj1vhK+R2Zt4G6BcKUJvlzyaczvfBN0Y7pz6DSVGJSoMYjY0CpLC9ZQfo0BghffQxN6
         96970WkcwrhZ9T6ataYKxduFR2fv+WwNR3gK3OQnbrunpC1UQvip3SaJ6wYW0pbtH3qZ
         JBC+7EdkhAG/eEboP5vwV3EUS8TY771zqDeGY+cfABhTTuo9j33Lrplvn/FHF/7QFebP
         RMUBOUeshragSYFz4Np8Ukc3CgHQ1r8bTW+Yso3yYwKhw7ywXUVNOt53D0Wsb+Y7Ws/z
         ERTg==
X-Gm-Message-State: AOAM530mNyVHGnGVXp8Z2WAaySs1xVq+euK/K7UJlgCpP9egqnuK+nfU
        HGBRE2ACnpiz9gvAaSoTmYVTDuIHYEDHow==
X-Google-Smtp-Source: ABdhPJwO2IpaDXKm7j+AEKgr/c7k2zLTz5Wwxrs7iL/4UBr1oBxG8IBXB1o7gAIn8tFM5sGE70CTgA==
X-Received: by 2002:a17:90a:6b0a:: with SMTP id v10mr6545606pjj.130.1633724390341;
        Fri, 08 Oct 2021 13:19:50 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id o5sm12196601pjg.40.2021.10.08.13.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 13:19:49 -0700 (PDT)
Subject: Re: [PATCH v2 45/46] scsi: usb: Switch to attribute groups
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <20211007211852.256007-1-bvanassche@acm.org>
 <20211007211852.256007-46-bvanassche@acm.org> <YV/Zf9kTcPbxzOXP@kroah.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b3266ddc-fb95-ef7e-92ef-3314d6043d7a@acm.org>
Date:   Fri, 8 Oct 2021 13:19:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YV/Zf9kTcPbxzOXP@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/7/21 10:39 PM, Greg Kroah-Hartman wrote:
> On Thu, Oct 07, 2021 at 02:18:51PM -0700, Bart Van Assche wrote:
>> +static const struct attribute_group usb_sdev_attr_group = {
>> +	.attrs = usb_sdev_attrs
>> +};
>> +
>> +static const struct attribute_group *usb_sdev_attr_groups[] = {
>> +	&usb_sdev_attr_group,
>> +	NULL
>> +};
> 
> ATTRIBUTE_GROUPS()?

Hi Greg,

I will use ATTRIBUTE_GROUPS() in all patches in this series where that 
macro can be used.

Thanks,

Bart.


