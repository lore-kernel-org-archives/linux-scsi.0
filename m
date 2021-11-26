Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE86C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 22:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbhKZW4L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 17:56:11 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:46644 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241928AbhKZWyL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 17:54:11 -0500
Received: by mail-pg1-f182.google.com with SMTP id r138so9327408pgr.13
        for <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2021 14:50:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=L23jasGX7Hk99b7bcCpg9U4YrOlpz5FDt+CSbdte3mg=;
        b=6wZwH8nAkP90rigg+KNh80DsFiks6RJuaCWM6a/CotPKF0hCLHxUIPIgLo+6WxL7fw
         Mu8uBZSp3bGeuxBZGdTUyMqrge2UV4gk5cWQSpw5k+Ynjo+OWL5tpOTkUEpQxsfhS+py
         zAxITTRgXJYuBXoX6FDcyFDTsvFVsDbo5nkzQ6anwubYxx/y/paVvHVRXHAT+UaGMhIa
         SAvQfeMw1eL3JdKQnv/VDENthcl8K95gIFNicKfzHcguiuEmCpKc7z1IWDY0KAQihUAV
         DOfyNQ4Ulq/SRz0K0ZK1noTLbRyUor0oVtcVs0Uk6mLf+uVPyyz05jN6GcZGrnsnamXX
         KWwg==
X-Gm-Message-State: AOAM533Ovi9hRT/QYGWtRjOg6XCGL1YeGjq9Rgr7nva11CG6j4uCqKmh
        OtBpEFR1xUegzVaq0iZ9CwM=
X-Google-Smtp-Source: ABdhPJymZ3bt50JMHpT4suvwn8l90RDdidak36Brhn42pVid819ksgDVjaBOUTg4ZXXY80zMjruHDg==
X-Received: by 2002:a63:9141:: with SMTP id l62mr23252274pge.30.1637967057639;
        Fri, 26 Nov 2021 14:50:57 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id lt5sm6372722pjb.43.2021.11.26.14.50.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 14:50:57 -0800 (PST)
Message-ID: <4288a456-067a-b0f1-25b4-c6fcd90bd558@acm.org>
Date:   Fri, 26 Nov 2021 14:50:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH V2] scsi: ufs: ufs-pci: Add support for Intel ADL
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>, linux-scsi@vger.kernel.org
References: <20211124204218.1784559-1-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211124204218.1784559-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/24/21 12:42, Adrian Hunter wrote:
> Add PCI ID and callbacks to support Intel Alder Lake.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Cc: stable@vger.kernel.org # v5.15+

Not sure Greg will agree with the "Cc: stable" tag for new 
functionality. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
