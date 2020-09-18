Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74216C43464
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 18:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11F8321734
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 18:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgIRSDp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 14:03:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46145 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIRSDp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2020 14:03:45 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kJKjV-0008Fr-Sx; Fri, 18 Sep 2020 18:03:41 +0000
Subject: Re: [PATCH] scsi: arcmsr: Remove the superfluous break
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Joe Perches <joe@perches.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, lee.jones@linaro.org, axboe@kernel.dk,
        mchehab+huawei@kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>
References: <20200918093230.49050-1-jingxiangfeng@huawei.com>
 <20200918145619.GA25599@embeddedor>
 <e9320543ab6e7c8bd5ceae8cfa9d0912a0e962e0.camel@perches.com>
 <20200918180037.GY4282@kadam>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <51f46436-75f8-441b-861a-ce607daeb09b@canonical.com>
Date:   Fri, 18 Sep 2020 19:03:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200918180037.GY4282@kadam>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/09/2020 19:00, Dan Carpenter wrote:
> Smatch just ignores these because they're often done deliberately.
> 
> regards,
> dan carpenter
> 

And I ignore fixing them when coverity reports them because life is too
short.

Colin
