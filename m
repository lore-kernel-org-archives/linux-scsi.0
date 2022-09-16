Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF8E7ECAAD8
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 14:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbiIPOKf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Sep 2022 10:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbiIPOKd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2022 10:10:33 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5C090839
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2022 07:10:32 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id fs14so21200987pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2022 07:10:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NEyG8j4IjaWlO7jCwgl1iFccURQgBDA/O4Ce316I9RY=;
        b=rZi+zWoIIpTKWsu0kMSSB8bLFFVarn+Ovl9vjE8l5HLfCmgLmoYnqNtVG5p1iL+0+X
         5WFMVtIsLL0kXjUAkOxjkFctaMy8BRbXa+UFEh3zALGRgyZ4VvYY/DvXqEcb9BDf5Ck3
         S+m78VRd9O2c5ddrV6dsPsMWpnWJPt3UolmSsSTOA8cgqECLTgV0O+Ft/IDvW/nbh/gE
         CacJBRtgGQYWpX88iU2JpRE2RmazglwqxW/KEwfEnnVZQKM6iaVI5CJNXwzuqSWSrB3q
         4bLoTkFyLiLXb898B3Y69Z7bxwUe8KRJqI3W2o+B2rYNpDfwbVXpqTWA8NjmEPiWTKEQ
         IbLQ==
X-Gm-Message-State: ACrzQf0YaqDss3TucBXJtaEGag9pKAIdOcv9J7RITGJN6H8YbHs32S9y
        mD2G9P37mkGep4kTFv0VyD0=
X-Google-Smtp-Source: AMsMyM70RlDiqUuxBeFMaBEF39vhtEmPMaLrPpxoO1VW+3dXWZWoNQlzngCJOZbuO3XFgeoGn/So1A==
X-Received: by 2002:a17:902:cec1:b0:178:cdb:8458 with SMTP id d1-20020a170902cec100b001780cdb8458mr5128plg.161.1663337431256;
        Fri, 16 Sep 2022 07:10:31 -0700 (PDT)
Received: from [192.168.50.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902a3c700b00176dc72ad88sm14748304plb.287.2022.09.16.07.10.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Sep 2022 07:10:30 -0700 (PDT)
Message-ID: <d40ed9f0-1149-6c49-0888-211a21808e2c@acm.org>
Date:   Fri, 16 Sep 2022 07:10:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] scsi: core: Add io timeout count for scsi device
Content-Language: en-US
To:     Wu Bo <wubo40@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        qiuchangqi.qiu@huawei.com
References: <32aff63d-1b79-916a-50e2-1e6c113ed9ef@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <32aff63d-1b79-916a-50e2-1e6c113ed9ef@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/22 19:01, Wu Bo wrote:
> Current the scsi device has iorequest count, iodone count
> and ioerr count, but lack of io timeout count.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
