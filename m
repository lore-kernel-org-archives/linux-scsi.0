Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63428C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiJDWqT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiJDWqN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:46:13 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77066C762
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:46:10 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id i6so14375207pfb.2
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:46:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=yYwtOh5vG4r4D/X8p5yR2gP4bRrKguEdOtXyXDNEqKQ=;
        b=unciZLhlvDnJqttx2Di/V3ieIOWKZRg+/87vLdGV4vjD4VL2sofjnfIc1B6YC1rQzF
         6F6fbAc5TVRVvDkAA69LngaIRKABOA+8CLRbauJpNdznaQYNMQSEAsk76oGfDIWUSsKK
         Hm7fRoUu48o0rg6pLejobycbvbThI9HfyDeFWlvLIfuIh5PQRuKSwM5Fik/nD3fKfu8Z
         5VgWW9TOn3zLcoxkbk+B4lqhN0phKYQxocIntbyFGYaBbERhU6CxpldfAuW+k7L7JKE6
         Z7r4ZnKn0GNcsONnQ/9io/IJCy25HLcHiwwcyjN0CTNO0XC4DmpzpDCIg7IxxeyAQYvs
         DzAw==
X-Gm-Message-State: ACrzQf2JEfVUNJi6krFfX9kGgp3tm84l5ayD/zrQnGJ3c/y+8P819MGf
        3SZ+2TuU0C6/KCcX0Za8np4=
X-Google-Smtp-Source: AMsMyM7LE5cApVuGd/PxvvlxAojt+KlpLbdF00bZgHAtX+aLsa1RPyhTn2xYyR42kIA5bteZJ4Ed4Q==
X-Received: by 2002:a65:6e9a:0:b0:435:6009:4b62 with SMTP id bm26-20020a656e9a000000b0043560094b62mr25388919pgb.596.1664923570137;
        Tue, 04 Oct 2022 15:46:10 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id l6-20020a6542c6000000b004277f43b736sm8701455pgp.92.2022.10.04.15.46.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:46:09 -0700 (PDT)
Message-ID: <5bdd79f2-63c8-1975-801f-f66fba485798@acm.org>
Date:   Tue, 4 Oct 2022 15:46:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 14/35] scsi: sr: Convert to scsi_exec_req
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-15-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-15-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:53, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert to scsi_exec_req so
> we pass all args in a scsi_exec_args struct.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
