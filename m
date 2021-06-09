Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820BEC48BCF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 19:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D2AE613D4
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 19:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhFIT7Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 15:59:24 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:40882 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFIT7Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 15:59:24 -0400
Received: by mail-pf1-f176.google.com with SMTP id q25so19365211pfh.7
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 12:57:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rMOau9BZ6Mz18+owOSDhOKsDHnEKUenQ/xwxQE7tMJE=;
        b=ohDokZnHPQRCa/3fBuLXZ3cC3xBtwClQi7oZ8C4056Nc4F72ZtLETPNyKtc9RMq/gt
         QQ53xfLq3qPahAnEetSemWF+zHVnJIXaw/I9X/D65d1IAayvwU+2dOZMdLfAqe0o9fnR
         ex80HOL8ONbOjICpmZ/rFuGrjnchmjEDBNVp91dDubntaO0rp/cw83fgp/3X+H4BGLPj
         HUT0zOcPE0HEOaTZWaZIFhn6m/L/IJMbHFEd3jZWrFQoZVnLwr6HhFtQSY4l2TkDcw2w
         TIUh2kbjrrf0fZDe8AAbxXgvXvFBmNJHB7C4PodHb4mJwW47ik4Ozr0CNqXMSiYgveQC
         yklg==
X-Gm-Message-State: AOAM533MZPJFtA+mZk4RCIizEgN5FEcdtQ523R/XQZxlDnpVubpt7mgr
        H83UjRLZi+WrCxfL1TN2oe5iSgeABQc=
X-Google-Smtp-Source: ABdhPJymyDI3w6JUmkW7Np77rhz3Wx+F7GZlHLv3pYT+xGZH/jCahI6M9x5YYKddJUmrtV4i/3mZFg==
X-Received: by 2002:a63:5a5d:: with SMTP id k29mr1266335pgm.215.1623268632492;
        Wed, 09 Jun 2021 12:57:12 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v67sm336579pfb.193.2021.06.09.12.57.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 12:57:12 -0700 (PDT)
Subject: Re: [PATCH 12/15] scsi: core: Make scsi_get_lba() return the LBA
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20210609033929.3815-1-martin.petersen@oracle.com>
 <20210609033929.3815-13-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <93dff9d3-70d4-3f0c-bb1b-b123bcb61b86@acm.org>
Date:   Wed, 9 Jun 2021 12:57:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210609033929.3815-13-martin.petersen@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/8/21 8:39 PM, Martin K. Petersen wrote:
> scsi_get_lba() confusingly returned the block layer sector number
> expressed in units of 512 bytes. Now that we have a more aptly named
> scsi_get_sector() function, make scsi_get_lba() return the actual LBA.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
