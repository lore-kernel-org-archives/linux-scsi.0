Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 895FAC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6155561263
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhDZDcY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:32:24 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:46855 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhDZDcY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:32:24 -0400
Received: by mail-pj1-f43.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so4442019pja.5
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 20:31:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LPnCgkRFpLrb6r3YjvNSD/uc5sTpkx81UNk+cEFgcT0=;
        b=tKMbFrE9/MKaDXNVTyRoSVLuEmzrIAPvTNdsjf2jpRtMSv3pix4mWOHuw2myw/p8ki
         DuwXTeCDb18y8v002qcV5yOz83IPmRwl+LnNKge3xmtOxxnMnuRDwBL6VNU4FXTCeDNd
         uWoDU0eaJ70ND0O+ahlaCsHpPdCbVtSvMhK5A9LL9fFYvilLlIBHpesyMaBGTwvxkREL
         tSp9/vV03wpyry/RYd0uSz+zSL0S++SUS0NfeeYCCLAwBsD94+uFwtZHam/KwIf3bbW8
         me/6fuU5AmzQ03tLtZ/3eZWRJjdOGHPIovXJcVtoPpH5RSOow7MEv6/o49Xn76r/C34x
         ooAQ==
X-Gm-Message-State: AOAM533FxHo0o0v5KIvzpLnMMb5Xi2Zqycw1AZdDHCEFK1ZwDAJkcCia
        MAQpGAtfFnkI7Osw21ZKe01SIp0sg9qs5w==
X-Google-Smtp-Source: ABdhPJwGu2V2sbpSgpTWpP1DK5/YQgSa5uyMDHyI6uqHOOpaelxN7xoEpDBx6GqXvf8kXfJxJKXc/A==
X-Received: by 2002:a17:90a:303:: with SMTP id 3mr20472975pje.36.1619407902622;
        Sun, 25 Apr 2021 20:31:42 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i126sm9421324pfc.20.2021.04.25.20.31.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:31:41 -0700 (PDT)
Subject: Re: [PATCH 06/39] scsi: introduce scsi_build_sense()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-7-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <07943b38-51e7-b22b-a098-d97a043d82d9@acm.org>
Date:   Sun, 25 Apr 2021 20:31:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423113944.42672-7-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 4:39 AM, Hannes Reinecke wrote:
> Introduce scsi_build_sense() as a wrapper around
> scsi_build_sense_buffer() to format the buffer and set
> the correct SCSI status.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
