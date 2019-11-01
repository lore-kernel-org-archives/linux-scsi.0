Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33898CA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11D2720656
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbfKAQ3b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:29:31 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41972 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfKAQ3b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 12:29:31 -0400
Received: by mail-pf1-f195.google.com with SMTP id p26so7408122pfq.8
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2019 09:29:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G6djl06Q9x8KfD6SHOrzpm0oC9UmxKSVRg1VzV1v2Vk=;
        b=EjTFEGcta3lVEkW369uhhc81mFsRV9CX5IICVgZXW2jShkiNp24v1l4FjO8JFJi57r
         7LtU4Re9ZHs24TctrEjfvPFAeeiwswUzMi4HmdSInqkHF2rWaBMdiX7qU5bm0dHUGbG4
         WtShJT6bml2eG8NE74fg1ieKQoqV1vFulecmei/+0U5Y1dnc9VUujhhFMqOdwWmT/l6g
         CyTaWOtvvGUT286LztQnpo76UhYKNVFj2ntrb8/BQFSlf7SyGU/aTAPoy8F1udDh/Q7p
         f84V7po+e3VZIc2uX/cne0sayLOBIemX9t0Oulszz3Nn7SW/pFt0gJd5D4KwrEUZmrSY
         Dt8Q==
X-Gm-Message-State: APjAAAX32k3mJCu+ZXiyVZzCxYLOME7fF4JsgbpLhwWgAggsR1cOqaYm
        10llAxSYR9MxInLFF7GJ5QpJuL88/DQ=
X-Google-Smtp-Source: APXvYqzNmSjYVTnOZNbmMPjs/DsfTtfJf3Ncb9w5FXRr30MQcJ6gWvzb5spQ8wPpCMrmlwwob1oJ3w==
X-Received: by 2002:a17:90b:282:: with SMTP id az2mr16239657pjb.23.1572625768914;
        Fri, 01 Nov 2019 09:29:28 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p189sm6972395pfp.163.2019.11.01.09.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 09:29:27 -0700 (PDT)
Subject: Re: [PATCH 07/24] target_core: Fixup target_complete_cmd() usage
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191031110452.73463-1-hare@suse.de>
 <20191031110452.73463-8-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <35232ba0-59d0-1e43-340f-ebd26b144438@acm.org>
Date:   Fri, 1 Nov 2019 09:29:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191031110452.73463-8-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/31/19 4:04 AM, Hannes Reinecke wrote:
> target_complete_cmd() occasionally still uses the linux-specific
> SCSI result values; fix it up to use SAM result values throughout.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
