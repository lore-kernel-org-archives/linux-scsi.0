Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44128CA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27E6220869
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfKDRtD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:49:03 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43922 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbfKDRtD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:49:03 -0500
Received: by mail-pf1-f193.google.com with SMTP id 3so12758113pfb.10
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:49:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W4M48syZy3IOG6k9Wnu8Z92P0trNI+sdDvtZ8y97oLE=;
        b=p9k5dmVQbZpMG93ovBQSHi1lBk03P0VIFfT93OOkF5t7RFT4RGeNKsifs6rVrX2hZv
         zo74W9ajhh0FlbXFgQcon/vuWk53APgTj/jZNUNs/cCrd5ED7bB+e/H65t8/xIDR9sbq
         Z1agRvYBOmQIOUMImXZQZIzd9cSNe/Kt6iQBq5OWw/On2Fw7sEI8lt6ud/9z2q/zAZ1B
         gH/C5w8dXUL/yXzYPXmieeKIBxjU+lz/yMM1Ve5wSNITrlzAKtelmVZNISRGKom/9vNx
         cAT+Sk0Bq10MnEJqigP1xxz9w7DfdSJbL2OxW71tYiwqOeknj8PWhxuvunc/pUAYqAqv
         QtUA==
X-Gm-Message-State: APjAAAVMgPDwARGN5ZbwVoF6lLvI9ZhXGhtvbg2tLlCNmwRhEo7Xki7s
        Fn/b9Ns3mK90tmJGBr5YHbSH9cBV
X-Google-Smtp-Source: APXvYqzqaiz3tU2TlpW+x/tjykGe0VvX9JpYBmcfEI7jRB14VKy0QvvXtTjfm5RxE3gciEtD0FkowA==
X-Received: by 2002:a63:eb08:: with SMTP id t8mr32253162pgh.49.1572889742468;
        Mon, 04 Nov 2019 09:49:02 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id s5sm14410652pjn.24.2019.11.04.09.49.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:49:01 -0800 (PST)
Subject: Re: [PATCH 27/52] zfcp: use scsi_build_sense()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-28-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c90dc7df-41d4-cb80-1311-46ba8750e475@acm.org>
Date:   Mon, 4 Nov 2019 09:49:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-28-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> Use scsi_build_sense() to format the sense code.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

