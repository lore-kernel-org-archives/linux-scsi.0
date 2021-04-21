Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFFDC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 22:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F155761430
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 22:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbhDUW11 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 18:27:27 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:37729 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbhDUW10 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 18:27:26 -0400
Received: by mail-pg1-f169.google.com with SMTP id p2so15862986pgh.4
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 15:26:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RY6S4C5lOcRQsKUJEqWAJxsE9gND8+hWLiuolPIIPp8=;
        b=GvZAPdwaq/jeLIxor4xGOGYp+GKqGzIzj1BcFOkqYGXHJ/wsz8NahmHSRne8CPe7vP
         5PmQfENhCyZMsGkdpn7fFelNDOjwEaYMCaV/sm8/nDiIEhoAyIbdjOMMBMNr/oH9eQbW
         mEvmMkUw7vch1lD51oSHnWvdr/VnSdIQO8MFT9cLBy+spY5v+VcMTp4TB2IbiTB/SOTS
         er9dlIwNF6ZfIosDK24OtJSDsi0vyvSGnLWlq5QS/13KJjrXYUTFwFALPZo9ifTXhggc
         VZetHEOOvByiyACboTWiC+jYUfnFflH5oPrKS48eF33z1axIeGU3x+0lgTTTsDB7I4e6
         wymQ==
X-Gm-Message-State: AOAM533eysRbbVftpKm4xA9tSPm9xN8X33dezcKrEn2UGZfFNnlJCYCj
        Ec7FlHaEnLv73PIMcMICv2JJM/k/7EWUeg==
X-Google-Smtp-Source: ABdhPJwlw4SxTBFuKJF+PH5VNJBXgufRcp5hGZbTpKhFAGthCtKwpouuiFA9FoQ+mCV3OY8J1GL+Og==
X-Received: by 2002:a17:90a:bd13:: with SMTP id y19mr14437474pjr.181.1619044012880;
        Wed, 21 Apr 2021 15:26:52 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id l22sm3047530pjc.13.2021.04.21.15.26.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 15:26:52 -0700 (PDT)
Subject: Re: [PATCH 18/42] dc395: use standard macros to set SCSI result
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-19-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d92fd9b0-c10d-a3a3-99ba-e4d34e0888a0@acm.org>
Date:   Wed, 21 Apr 2021 15:26:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210421174749.11221-19-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 10:47 AM, Hannes Reinecke wrote:
> Use standard macros to set the SCSI result and drop the internal ones.

This patch looks almost identical to a patch from my patch series?

Thanks,

Bart.
