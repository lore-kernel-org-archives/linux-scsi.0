Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA53C47E49
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B147E214B2
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbfKDRg2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:36:28 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40201 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDRg1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:36:27 -0500
Received: by mail-pl1-f194.google.com with SMTP id e3so5771368plt.7
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:36:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+dph0Raqdsf//+GDu2MAr+c+IolWVXOaz7N10yfWb6g=;
        b=F4x2ZCzTQ4ZWnnU7lknD4B55S5qRwAvZpQzwc2sFVfMZLK9jfTe7TCwJ/5Bj+1zs42
         dwxon69nvw+VaUuKyKP2fXXrr7BkkXG1xjQZp/+GtARD7bMuqt0NVoaPxHpNYizYcuTe
         +cgOB5lkdeAoHGc/07q9bHJKAxUZLPIQwHNW+m7yA3KFmfGOwnd4k1rV9NNrw+3Y/FTv
         Qi2aHj3zWkeaN8Klu4C5ROMi8QdQocmtXdfb9YkD/0ejn35e8Bv5cKebjKFV6bJzl+Qo
         SYpgBucnbhbDs97Yfg1aQLPh5SyyDDTUS/xaZ8n2DTfzqkRUndfTei7xMZ2KYfDMLEH1
         MLnw==
X-Gm-Message-State: APjAAAWKxOEIofpHVpPxgdcSCpj163VuNmuHSqQEnUFHI2F/3jeU0rf/
        RIfKzNSyCDCgQWhfxkfcl2cxTG3E
X-Google-Smtp-Source: APXvYqzCOfjjxng4h1QMjDprPxtwVNF+78XU0bRda7AK0Ug8xioCs+rKdBcnSeX7+85+P7Y4qbRMTw==
X-Received: by 2002:a17:902:59c9:: with SMTP id d9mr27448362plj.229.1572888986667;
        Mon, 04 Nov 2019 09:36:26 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id e17sm14281500pgg.5.2019.11.04.09.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:36:25 -0800 (PST)
Subject: Re: [PATCH 05/52] libata-scsi: use standard SAM status codes
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-6-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a58c272a-9b51-0bd5-ea8c-0c03f2d8e9e9@acm.org>
Date:   Mon, 4 Nov 2019 09:36:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-6-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> Use standard SAM status codes and omit the explicit shift to convert
> from linux-specific ones.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

