Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6AE0C63697
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6085D2467A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgKQQqv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 11:46:51 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:38100 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727439AbgKQQqv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2020 11:46:51 -0500
Received: by mail-pj1-f65.google.com with SMTP id gi3so804201pjb.3;
        Tue, 17 Nov 2020 08:46:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s43DkhroP2fE2p52MdenTBrlylmGcPquO8ir0v8/P+k=;
        b=VBsGMpd9gkhyUTKC7WBTIFs2tvZ6Wlo7Yl74FzVYob9iOXUCQrHTVpzVCOyGfZLomI
         8cbF3RQqBi9cKqT8/u0P9oYxQvIhWctHfUx3jbMvUhwA4JhdZNqlCUZtbosQBaQw46dk
         uomMVL0RMikI7kFgVIlvvYqyCTUiwiwKCCLKWolFmvqnexSjufn4DUwdk7IrSubpd27v
         wEEoXxHemsku80o2PzA/Jc4qzGz8yzaQvcVdPmN0oY4qvLSS6B7IYkVDtyYnMeLnibax
         pqZrQglgCNxOFLLsNWMRadstRQNvZK8UpYHVXBew5rWJAB7EMQXjbTWjyWFgVRk2PUzB
         MxSw==
X-Gm-Message-State: AOAM53282rKgcI2BxJFOSCEFzzexlt+64REo3hhRhkfi7gEO4GGMSEX4
        UeKj+hc5vtybtvzJBeV+fMRhvJ5MNFQ=
X-Google-Smtp-Source: ABdhPJz0hqwFgrU/OtvJed64cAOwajiwlODGtEkQGu6HWuBNUwihdbumB1I5mFm6Z4kOFMlk7z+DuQ==
X-Received: by 2002:a17:90a:5b0a:: with SMTP id o10mr228686pji.197.1605631610234;
        Tue, 17 Nov 2020 08:46:50 -0800 (PST)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id t7sm3592605pji.27.2020.11.17.08.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 08:46:49 -0800 (PST)
Subject: Re: [block, scsi, ide] 3e3b42fee6:
 kmsg.sd#:#:#:#:[sdf]Asking_for_cache_data_failed
To:     kernel test robot <oliver.sang@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        0day robot <lkp@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org
References: <20201117143350.GA17824@xsang-OptiPlex-9020>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <38bed525-3453-f614-7310-ad01f1bc2605@acm.org>
Date:   Tue, 17 Nov 2020 08:46:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201117143350.GA17824@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/17/20 8:00 AM, kernel test robot wrote:
> on test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz with 32G memory
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>

Please fix the test bot. The DID_ERROR messages are reported during test 
block/001 and in the attached dmesg output I found the following:

block/001 (stress device hotplugging)                        [passed]

Bart.
