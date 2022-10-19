Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD44C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 22:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiJSWJG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 18:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiJSWJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 18:09:03 -0400
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79531BF851
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 15:09:02 -0700 (PDT)
Received: by mail-vk1-f176.google.com with SMTP id q83so8951384vkb.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 15:09:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sb3+wdk6yOZSXnY/zXFqLlidblv/Ceo/qcudPSUiy/s=;
        b=5PQ2BYUgB2+BZGVQmFnzc0TizRTXVuPbvkBalCIIc3sA0dPIoPBpLJeknWNw4Tmw7I
         mndaqX677HKd7Nn33EKjUR6PxXX1atfJbz1BL/dmvI9mAHYeZ1cu7wjLOe1klAPByB2k
         GOp7ECugVxrmGL/theIFRoKlX2W3UtDarwGBmqe4N54PrTaJPtb3dLSfAzBe7+bhkirr
         p7cUlAomxsNwUE1chD1SV8lLON8JoFwdUogbowcoTF/9D4HQsK/Vc2z98Ad0ccCgNoMg
         3BkrGinWBSZFG4FAJV+1ht6vRFLggzgj74PR8m+A1Dw1Yu/Ly0WpJe0yqgN1Y6xeGlig
         4fLQ==
X-Gm-Message-State: ACrzQf2ghkyjaGjihGGklpn5dC9yKPKts/9l5nh58X88bCFS735w4xYs
        oi1ReCd5v7l5G4stU74EQDGNeVSpNWE=
X-Google-Smtp-Source: AMsMyM7d/ui3OqA7OVV1XB6u3nLQ6wudemTR9bwL9cHTeuFtMmhkDP4ZrqbD9oDKZyPOyJ9/HtWRpw==
X-Received: by 2002:a17:902:7b87:b0:179:ec0a:7239 with SMTP id w7-20020a1709027b8700b00179ec0a7239mr10818613pll.139.1666217330939;
        Wed, 19 Oct 2022 15:08:50 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:8280:2606:af57:d34? ([2620:15c:211:201:8280:2606:af57:d34])
        by smtp.gmail.com with ESMTPSA id h8-20020a056a00000800b0053ebe7ffddcsm11654516pfk.116.2022.10.19.15.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 15:08:50 -0700 (PDT)
Message-ID: <db52d0a1-904b-682c-fdbd-84f49952909d@acm.org>
Date:   Wed, 19 Oct 2022 15:08:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v4 20/36] scsi: Have scsi-ml retry scsi_probe_lun errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221016195946.7613-1-michael.christie@oracle.com>
 <20221016195946.7613-21-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221016195946.7613-21-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/22 12:59, Mike Christie wrote:
> This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
> itself.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

