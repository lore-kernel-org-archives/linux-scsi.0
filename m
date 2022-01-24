Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5099C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jan 2022 18:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244949AbiAXScY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 13:32:24 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:46719 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbiAXScX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2022 13:32:23 -0500
Received: by mail-pf1-f170.google.com with SMTP id h5so8425186pfv.13;
        Mon, 24 Jan 2022 10:32:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GLaZfB9I2LW9NeKFD2WW2Oku6S9Lctym5AUPyw4r0EY=;
        b=fajSdkh/uKwUew1ftRiCsi8O3SO0Mmcm29q7zxCoBpfQ7JwdIOHbbOp7EKb0qxUh9G
         X2K5iU7a8dJWo5z59hWFglTUtRcU9SN1IzxFuhys+KVxHpwtsSGtkVooR+ZyuYAZmaxZ
         x+GBq85tyQn3YD/H9YxP5kAu0IoJ+c7hDfyYGuCXECgU7sCdiI9zmlU7HSkT0D+CJrYg
         1OVIemcO9OffQSFY2HB4Knd3W4uduEmQ4+ZsUJXQfVOJP8Xm+IS1mumZvbI0sX6WwnU3
         5ooi50C1OnMu4TfodV8sdECLPmreY7EB4/uQDRF8aVDbdHrtCW9Q0jXCV1SqQyBpv6Sz
         1odg==
X-Gm-Message-State: AOAM5308gs+bRi3Q8lc9pEev/rMlgt1TnkWtovGy+RkTQo6LB5mq3pyi
        6B/yy6fOXgcGVV5SNGdMa4U=
X-Google-Smtp-Source: ABdhPJzA51riiYOrypw+qulVvPjMNxUCWtPJGWOxpGCXrMtb9yuuv88+rFUnia/iPBRRB6INTPErIQ==
X-Received: by 2002:a63:205:: with SMTP id 5mr12627815pgc.379.1643049142834;
        Mon, 24 Jan 2022 10:32:22 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id l21sm16939528pfu.120.2022.01.24.10.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 10:32:21 -0800 (PST)
Message-ID: <db0d9760-9cff-e85b-ca2a-003c297322d1@acm.org>
Date:   Mon, 24 Jan 2022 10:32:19 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH V2 02/13] block: move initialization of q->blkg_list into
 blkcg_init_queue
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
References: <20220122111054.1126146-1-ming.lei@redhat.com>
 <20220122111054.1126146-3-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220122111054.1126146-3-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/22/22 03:10, Ming Lei wrote:
> q->blkg_list is only used by blkcg code, so move it into
> blkcg_init_queue.

Should Tejun be Cc-ed for this patch?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
