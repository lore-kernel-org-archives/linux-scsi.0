Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64F6CA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A570521734
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfKAQO6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:14:58 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:36577 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbfKAQO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 12:14:58 -0400
Received: by mail-pl1-f182.google.com with SMTP id g9so4584560plp.3
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2019 09:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lq63VDid4CXop2lDcKhNJJJ4MfZ4UhL1R0SiLcDdHJ0=;
        b=hMS8ED8MlKTbWMayQWHStpsvSbsPEbU6Cm+OIEYGePkY1DIiUTLZMbU3Z8vxLikS6C
         mTeT3bUiSIh7K6D297iMt47/uYyovxdJg7FT4OpYSOM1I4890lVrcAZcHnU8kUnv1MUE
         wDybIWelDYehrIW4uoYXo9voce62FORKuJT7ojPYdJg1SDlwLYuCuWrr0mC7E/5cm9jD
         +z9/vPTcUcFDu1bGpNWfsKh/Yr4krvJX1n4wvCf8sC3HstzTSrEdEng6SU4TcLzPVs+6
         O3Cwq7bAGNoExlcPRnK4xXUJ+DUte59JVybp7P66ZXzEYRr9rKoNZmQAYMK5razQyZ9h
         l6YQ==
X-Gm-Message-State: APjAAAVvxfec7JulrwvsHj9tDDW4QnGus6yLW1k0oGFvexxD8qkNEdIO
        X23t1DA0niNbSUZV6GTsAX1oxsEq+W8=
X-Google-Smtp-Source: APXvYqx7DT950w45dtxOowAwBNqgAyfd/wukJ/GnzJQInHo8+CArtpgRPCzjcrzfQk8GvAUOImT2WQ==
X-Received: by 2002:a17:902:142:: with SMTP id 60mr13655723plb.38.1572624896635;
        Fri, 01 Nov 2019 09:14:56 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id b59sm7982667pjc.14.2019.11.01.09.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 09:14:55 -0700 (PDT)
Subject: Re: [PATCH 01/24] aic7xxx,aic79xxx: remove driver-defined SAM status
 definitions
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191031110452.73463-1-hare@suse.de>
 <20191031110452.73463-2-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e91db3c7-4b04-1d26-7641-335eddb6f75c@acm.org>
Date:   Fri, 1 Nov 2019 09:14:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191031110452.73463-2-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/31/19 4:04 AM, Hannes Reinecke wrote:
> Replace the driver-defined SAM status definitions with the
> standard mid-layer defined ones.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
