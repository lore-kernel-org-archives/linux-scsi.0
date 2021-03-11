Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1049AC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 15:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B05D564FD6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 15:14:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbhCKPNi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 10:13:38 -0500
Received: from mail-pl1-f173.google.com ([209.85.214.173]:46443 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbhCKPNO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 10:13:14 -0500
Received: by mail-pl1-f173.google.com with SMTP id a8so3826234plp.13
        for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2021 07:13:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m6/ZBFrT+ir3yK6uJlPBfpXETyX0jXrTsgcDadGtEzk=;
        b=ASwxjAc+l8Zrgk1aXY10RcYKCDbgSqkaea1F/hDUxW9ILpcXuxFn+qTfwRWM21i2fN
         e/6Bpor8sHzt7zbRa+q8xXYv1Qxt36FsY6CtyUXba7y/SDsp50+mBBG7M1E4LRZUz4u+
         rDgeLkq1oEL0OVurW1ZtB/W6JMt3emA0NM7mmYMUooWaQujbxSwHnG66qNfUe5j1Lj6H
         Wn3swWadHNBHKCdknL54DlQfJwZyM8E2noKmlp66lD90mTCFO5gbc/gam6WPjcWC/ANI
         lZcOlRYx3I+zfNrwZjL+FRpA9Tk1LpzsWnquKkTG05DBTJ1q/46myDLKpkSUvECrKBDW
         T68A==
X-Gm-Message-State: AOAM532WT+1GBjJjEcFZ4DLy6d2SZ32yRcdBeR4IU4qG4AODSt1RrA0T
        1bLWzCXTUSM0EnqWswKlXnhtYUcu2J0=
X-Google-Smtp-Source: ABdhPJw62db7sh0iAQ0QMUcwNsmx4rj9XFW30QuGIf7Yj8O1UZePO160G02Iimyp8OiYVBUQ8yegwg==
X-Received: by 2002:a17:90a:ce82:: with SMTP id g2mr9405332pju.193.1615475593749;
        Thu, 11 Mar 2021 07:13:13 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:c25c:5b7c:8cae:df7e? ([2601:647:4000:d7:c25c:5b7c:8cae:df7e])
        by smtp.gmail.com with ESMTPSA id e1sm2650184pjt.10.2021.03.11.07.13.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 07:13:13 -0800 (PST)
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        linux-scsi@vger.kernel.org
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2a68a06c-7bcf-337d-b819-9e8f63f5e68c@acm.org>
Date:   Thu, 11 Mar 2021 07:13:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/10/21 1:48 AM, Johannes Thumshirn wrote:
> Recent changes [ ... ]

Please add Fixes: and/or Cc: stable tags as appropriate.

Thanks,

Bart.
