Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA67C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 15:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB91160F41
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 15:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235471AbhKLPmI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Nov 2021 10:42:08 -0500
Received: from mail-qt1-f178.google.com ([209.85.160.178]:37392 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235493AbhKLPlq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Nov 2021 10:41:46 -0500
Received: by mail-qt1-f178.google.com with SMTP id f20so8472611qtb.4;
        Fri, 12 Nov 2021 07:38:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=N5V65Ao2NSOslG/cgmP+wOxwtRJeUsntlYPC91JC4tdb+I3z2uUf2shRUg5VrMQanf
         mEK15PkjfYBK/0F8ZlNkVOe6XOu+1mwjqOyiiCOcKSYAKoZjwtM/Mc7Uw6q9MuvuZQVo
         yuBFa6fDeqwB2yUlJ5AKsCIm+em+hscs4vOJLJLGZvx9uSZ3WtUWqVPjxbq2oXr8CZwX
         fhx4Msk5SZAWBsTcboFgREq5Zr8PWcOoyXTZBpqXMRyTW9BOEUYGx3zSM84f5p9+ozN5
         EyP7V1ywemrYXVnVbYyNg8j4XuCCrO+XGyUL8FR8f2DOxHQt0gt8Lq1kzbt5D+knFxs2
         zsKA==
X-Gm-Message-State: AOAM531Osa81cxpQTRT/C5LO0jK0PHLSXF4pH7cBxQqo4rxEEmnIELml
        8rt7ZFxZ/fhKlUesNMmN32U=
X-Google-Smtp-Source: ABdhPJyNHeu9f/ZUxvOfxORx124sMvrbBsqcA7M4TM/h+R2WxA+t8TF0JDonrogyvFS5J2fkxYVjCQ==
X-Received: by 2002:a05:622a:1a93:: with SMTP id s19mr6774258qtc.291.1636731535094;
        Fri, 12 Nov 2021 07:38:55 -0800 (PST)
Received: from [192.168.4.254] ([72.166.42.242])
        by smtp.gmail.com with ESMTPSA id bm35sm1893202qkb.86.2021.11.12.07.38.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Nov 2021 07:38:54 -0800 (PST)
Subject: Re: [PATCH 4/4] nvme: wait until quiesce is done
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <20211103034305.3691555-1-ming.lei@redhat.com>
 <20211103034305.3691555-5-ming.lei@redhat.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <0f098e85-0da8-6337-5fba-b6e68a6d2ad2@grimberg.me>
Date:   Fri, 12 Nov 2021 10:38:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211103034305.3691555-5-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
