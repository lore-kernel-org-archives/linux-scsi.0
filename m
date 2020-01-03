Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9B7C2D0C2
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 20:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDC0421835
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 20:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbgACUpd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jan 2020 15:45:33 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35975 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgACUpd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2020 15:45:33 -0500
Received: by mail-pl1-f193.google.com with SMTP id a6so18700212plm.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jan 2020 12:45:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KswqLj9n+63iTTN+tAb52pHlE/Z5/lUqgi0JGdp7Ip8=;
        b=EtmvDniOF89O1k7aSJL9YxiDqQQwT6RtZZa9FP1xwQalP7aRTIgbTlFm1lgarie0CE
         Bn3DyCTAKF3k4sxGAMskRmOYTIzTtKIQvudeZ8SudeSPX9pxHot1gCdFbaa3u1vHA6E6
         WI+Bq5pRF41crv9nPbFV6XcoDbwg1QaoE/XGYUmq//No4bt985kmv8MwhA1nwy2nf4tZ
         H68j8zOV37YxgosGf0dIMJNp2R1XtWZaTB2thOBSDpoUeAqfqyWrSxPFZkRRH1hBFxSS
         /a8dMNMlSOLr1/zWRG7n+A093YBltEk0SWWHtM1fHAhhzWa+2qD9ORtIy/xQRjCrZhgG
         /oEQ==
X-Gm-Message-State: APjAAAXH9AgW1E49QZWLfv2jywG79g47QihyR+susnG8+KJ0cCyDKfmW
        ppYHJu2TRuvV1hcBfGmIcw4=
X-Google-Smtp-Source: APXvYqyozGyxcxeMg+9oQ6zYKy8i0GWwGetaNvs17Ig32VPlhbrGgZ66eLWMt1hAUgOztl0oLW2snQ==
X-Received: by 2002:a17:902:bd46:: with SMTP id b6mr93533429plx.239.1578084332754;
        Fri, 03 Jan 2020 12:45:32 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id z30sm70349825pff.131.2020.01.03.12.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2020 12:45:31 -0800 (PST)
Subject: Re: [scsi:misc 58/85] drivers/scsi/qla2xxx/qla_target.c:5326:35:
 sparse: sparse: cast from restricted __be16
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <202001040422.6EbHYDMc%lkp@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <351dc718-68cb-99e7-1056-778af8be5c9b@acm.org>
Date:   Fri, 3 Jan 2020 12:45:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <202001040422.6EbHYDMc%lkp@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/3/20 12:18 PM, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
> head:   c53cf10ef6d9faeee9baa1fab824139c6f10a134
> commit: a9c4ae108610716140bdec56ae0bebbe1c5cbe49 [58/85] scsi: qla2xxx: Use get_unaligned_*() instead of open-coding these functions
> reproduce:
>          # apt-get install sparse
>          # sparse version: v0.6.1-129-g341daf20-dirty
>          git checkout a9c4ae108610716140bdec56ae0bebbe1c5cbe49
>          make ARCH=x86_64 allmodconfig
>          make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> 
> sparse warnings: (new ones prefixed by >>)
> [ ... ]
Because I think that I don't have introduced any new endianness issues 
with the mentioned patch, please ignore this kernel test robot report. 
I'm working on patches that make the qla2xxx driver endianness clean.

Bart.
