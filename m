Return-Path: <SRS0=dnTk=4N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B111C35DF0
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 04:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E803E2467C
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 04:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgBYEc0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Feb 2020 23:32:26 -0500
Received: from mail-pj1-f49.google.com ([209.85.216.49]:52234 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbgBYEc0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Feb 2020 23:32:26 -0500
Received: by mail-pj1-f49.google.com with SMTP id ep11so700229pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2020 20:32:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pE6zqt3bnWGK3EdKXSF9UXMzNDDRg2FPxZwGmQ6FdxE=;
        b=jldg44jaTIuUgZVxdfSuQqGzLJY9UxFk76iKdOFwW6wrica0US3WzuT6ZohF10BMUB
         4llX3cQuGhoCUO4WcGTROvlSTieRBwvGfn0/6Ab7yMQP/mNJwklMViNyQfaulnw4vP6K
         nZjmZtlewTaZHoKI3/QrarBhOm/PJbPf1udR5th6kPEtkpiVVRTJObnbvQKTvQgIEN2A
         K+krxwxkJGkMa2pDgMU3FejaQYq204LdHVll+4jp2UsXsXEqAHhxTXsJyJyixOo6tqPn
         3ulGKMZb9wiZP5qkj5V6F2g4TzRpe+crIpo0fq7RiiLbClW8kImK50YffluI7IK7GiqD
         +nbw==
X-Gm-Message-State: APjAAAUN3vTjhHu+a8puVzWhCdGmlhz9CTG+F7GJtIPFx93wXOJKFp+N
        KeCOXDENP0BVSNtlq77soFicSbd8YvE=
X-Google-Smtp-Source: APXvYqztlmx52n467+LnLcnbu7rbltAmecbRBRlmrR5nbw6sIi/h343t5H6EISs8FUCETgZ4G7Ky+Q==
X-Received: by 2002:a17:90b:3c9:: with SMTP id go9mr2939545pjb.7.1582605145106;
        Mon, 24 Feb 2020 20:32:25 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:e0d5:574d:fc92:e4e? ([2601:647:4000:d7:e0d5:574d:fc92:e4e])
        by smtp.gmail.com with ESMTPSA id h3sm14494995pfo.102.2020.02.24.20.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 20:32:24 -0800 (PST)
Subject: Re: [PATCH 00/25] qla2xxx: Updates for the driver
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Cc:     James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
References: <20200212214436.25532-1-hmadhani@marvell.com>
 <yq1r1ynqzwv.fsf@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <5dd657a9-c9c8-088e-47ba-c324af4fe256@acm.org>
Date:   Mon, 24 Feb 2020 20:32:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <yq1r1ynqzwv.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-21 15:33, Martin K. Petersen wrote:
> Applied to 5.7/scsi-queue. This series lit up like a Xmas tree in
> checkpatch. Next time, please verify before posting.

Hi Martin,

Have these changes already been pushed out? It seems like it has been a
few days since your 5.7/scsi-queue branch has been published:

$ git fetch mkp-scsi && git show mkp-scsi/5.7/scsi-queue | head
commit b417107a659e9745f9ff905196ddff70cbe4eaa7
Author: Gustavo A. R. Silva <gustavo@embeddedor.com>
Date:   Wed Feb 12 18:02:11 2020 -0600

    scsi: advansys: Replace zero-length array with flexible-array member

Thanks,

Bart.
