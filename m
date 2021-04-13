Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52E4C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 18:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E20D613CA
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 18:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238639AbhDMS6A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 14:58:00 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:43531 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbhDMS56 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 14:57:58 -0400
Received: by mail-pf1-f177.google.com with SMTP id p67so7088546pfp.10
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 11:57:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0VxOUenzVp4N4rwwvUaY+2KKym0SM+jy+42HAn5XKXY=;
        b=OYWS0C1wURkNq1swh3xzXjQWs03XbHyXU/VxRCySdrFAaqZ2vNxvDn5FX8LMTDD6CT
         gH8kwoT8bWvRJGAFPWomecrlF/Ppaa+8W91PiZh9Y1Uh/bP73MhgXSAewvYZkCzevjBu
         2kQl4sUVIRQ0YrEJfe+d0bf9sit3EiUY+f7WMjEGGwuq8of29TnRsc0TzHd/h6Wnn/8Y
         YB/ebhbVKNUgFrpwsbCfVV2pVMk7M0HkU5DmOOEGTfTyKFoPuADsl9oPOeiCPO//I8x1
         U3jIN+7fHqf49Jn7oTQ0QMb2eJmmJAkjK/qn/E68i0EZl5uwrMxdvDJqso+1fhKXjRJo
         gplQ==
X-Gm-Message-State: AOAM533rWy7zedWhZvMHSBZ8qAdZNt+k/7fK4wyVEwL3+AgiuUVIRKx4
        D1BcYQ50eq1CbNWiH/vu29E=
X-Google-Smtp-Source: ABdhPJzH1jWsyreuX3iNpHEijsjJvWmxL8/rilZNZMqCj1WxcQxsB0ikWAXeaFsnm493OmkVuZukdg==
X-Received: by 2002:a62:bd03:0:b029:21d:b680:db15 with SMTP id a3-20020a62bd030000b029021db680db15mr30472843pff.25.1618340258005;
        Tue, 13 Apr 2021 11:57:38 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:345f:c70d:97e0:e2ef? ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id l25sm16112443pgu.72.2021.04.13.11.57.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 11:57:37 -0700 (PDT)
Subject: Re: [PATCH 09/20] iscsi: Suppress two clang format mismatch warnings
To:     jejb@linux.ibm.com,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
References: <20210413170714.2119-1-bvanassche@acm.org>
 <20210413170714.2119-10-bvanassche@acm.org>
 <605ae0b2be96ccaf15dc515dd67b4f32b289ba92.camel@linux.vnet.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e2577481-c340-17ae-30c5-326ac8a949f9@acm.org>
Date:   Tue, 13 Apr 2021 11:57:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <605ae0b2be96ccaf15dc515dd67b4f32b289ba92.camel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/13/21 10:59 AM, James Bottomley wrote:
> On Tue, 2021-04-13 at 10:07 -0700, Bart Van Assche wrote:
>> Suppress two instances of the following clang compiler warning:
>>
>> warning: format specifies type 'unsigned short'
>>       but the argument has type 'int' [-Wformat]
>>
>> Cc: Lee Duncan <lduncan@suse.com>
>> Cc: Chris Leech <cleech@redhat.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>  drivers/scsi/libiscsi.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 7ad11e42306d..0c3082d09712 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -3587,10 +3587,11 @@ int iscsi_conn_get_addr_param(struct
>> sockaddr_storage *addr,
>>  	case ISCSI_PARAM_CONN_PORT:
>>  	case ISCSI_PARAM_LOCAL_PORT:
>>  		if (sin)
>> -			len = sprintf(buf, "%hu\n", be16_to_cpu(sin-
>>> sin_port));
>> +			len = sprintf(buf, "%hu\n",
>> +				      (u16)be16_to_cpu(sin->sin_port));
>>  		else
>>  			len = sprintf(buf, "%hu\n",
>> -				      be16_to_cpu(sin6->sin6_port));
>> +				      (u16)be16_to_cpu(sin6-
>>
> 
> This looks odd: the generic definition of be16_to_cpu on le is
> 
> #define __be16_to_cpu(x) __swab16((__force __u16)(__be16)(x))
> 
> and __swab16 is
> 
> #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
> 
> So why doesn't clang see the existing __u16 as short?  This smells like
> a problem in the compiler file.

Hi James,

To me this also seems to be a compiler issue. I will drop this patch
since I prefer not to insert casts if an expression already has the
proper type.

Thanks,

Bart.
