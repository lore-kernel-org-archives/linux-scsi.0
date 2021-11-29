Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC1F9C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhK2TRj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:17:39 -0500
Received: from mail-pl1-f173.google.com ([209.85.214.173]:35802 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbhK2TPi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 14:15:38 -0500
Received: by mail-pl1-f173.google.com with SMTP id b13so12988697plg.2
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 11:12:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cD4yQ0YL3eRunkUOREi3189PL+3WcDinP8q/iyhQh7g=;
        b=pfk13j7k+HavYVaf6KVWjxzTaZWITTwAZE4XKMcuMxm/1uR/haRHsAoTScxjm/BJYv
         OONIVBN4jGDfKl9X8I2jcx7Eqb+syQ3jYI10mJhIHFKcy2VY7YKLxAdKPympdcjBvGQy
         UcV7Q0rhCRZTMFnLgtK2PUAVP5e5TojK+/q7+fPelDLdz/DRdQwBOHOKp7LHprZA53ey
         q9eWcsMwhhokMoPAkqdASJBXvf+cKyRfUReCqQ80TS75YBThv4q1NMxmEZWSGHPswTno
         3JWDBaBIBkkCcKvPjN3MAF7B3gP7rRoRbMqQXy+hGh2X3ZS8Zne82vT7Sv/atvUebu0S
         JbMA==
X-Gm-Message-State: AOAM531GSIR2nJo4O8nkKRt1xV9su5eaoqC48N5UbXPqJrMlmgkaxGvK
        TI+SJZd0113eoAonnItzDUY=
X-Google-Smtp-Source: ABdhPJyoSBXaA2VLzVxRpsiow5dct7odTITFuoIRmdmtKRy5riKcd+SfYIEtGPwSJmQlsXFODdprKQ==
X-Received: by 2002:a17:90b:4d8f:: with SMTP id oj15mr103874pjb.127.1638213140454;
        Mon, 29 Nov 2021 11:12:20 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a4a0:8cb5:fff:67db])
        by smtp.gmail.com with ESMTPSA id a8sm19171497pfv.176.2021.11.29.11.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 11:12:19 -0800 (PST)
Subject: Re: [PATCH v2 10/20] scsi: ufs: Remove dead code
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-11-bvanassche@acm.org>
 <a3b2b7f1-1ff5-ad71-9ca7-8963935364a9@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f540d7a9-7c90-4d39-ea57-58a6164de059@acm.org>
Date:   Mon, 29 Nov 2021 11:12:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a3b2b7f1-1ff5-ad71-9ca7-8963935364a9@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/24/21 3:11 AM, Adrian Hunter wrote:
> On 19/11/2021 21:57, Bart Van Assche wrote:
>> -out:
>> -	blk_mq_free_request(req);
> 
> Removing blk_mq_free_request() looks unintended

Oops, that removal was indeed unintended. Will fix.

Thanks,

Bart.
