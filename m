Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB230C433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 21:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbiCFVpd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 16:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbiCFVpb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 16:45:31 -0500
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8EF5BE63;
        Sun,  6 Mar 2022 13:44:38 -0800 (PST)
Received: by mail-pg1-f178.google.com with SMTP id bc27so12013617pgb.4;
        Sun, 06 Mar 2022 13:44:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0Y8l7Wr7JKstaxhPw6K6bnHxAKOkbmMgNqf4Nm8WYO0=;
        b=p0grgXvzL7jRuAbXjG04h2g1xFIZt2u26zlBE4hY4YQ5HWN1j/56wiboGfqj9H57i9
         ggRDvrSbkXKYpUwuQJo8o7Tn/SY7e475Jmge1v/McsNXjMrld4dot5pzv7+UtN5mA4k8
         QDuG2j0QTO89rxw2s/FPYeq4Tga9e/5M/IryPCss3VxLRERIWldTzTHdFJfWU943Hp/u
         OXrGTUq7J9yi3swVWZ0QRX2gJfNA4OHISFSpgs+py5CwxoWzR1fX7guELZDl7zcEi4nb
         p4kF99Jel83lXx+nk0cL6ER3PP0KSZl4g347UE3n2eZriU432JvJ1ymEsfEUJiebnnTY
         CB9g==
X-Gm-Message-State: AOAM533vQfT9OTaJ5+rmGWLIp1IujxoD4REGltEiarEXbfhyOhQ4tIrC
        +Hmw3bSVjHA4T1LixH+gQDhu7RPXRS0=
X-Google-Smtp-Source: ABdhPJxjssKsIioAg+j4nsOqfuzMXySE3cd058Z9BSB7/U3vqP07d0p6W3MfLk1j/A0sB57vu4kC+w==
X-Received: by 2002:a05:6a00:841:b0:4f3:d181:371c with SMTP id q1-20020a056a00084100b004f3d181371cmr9878947pfk.76.1646603077940;
        Sun, 06 Mar 2022 13:44:37 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c5-20020a056a00248500b004f6b5ddcc65sm10090308pfv.199.2022.03.06.13.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 13:44:37 -0800 (PST)
Message-ID: <a792e8ea-1b9a-f2ac-5b51-5fc3b39c1f6b@acm.org>
Date:   Sun, 6 Mar 2022 13:44:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 08/14] sr: implement ->free_disk
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-9-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220304160331.399757-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/22 08:03, Christoph Hellwig wrote:
> Simplify the refcounting and remove the need to clear disk->private_data
> by implementing the ->free_disk method.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
