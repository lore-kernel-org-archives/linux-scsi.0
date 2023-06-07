Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA1C2C7EE25
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 19:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbjFGTKZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 15:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbjFGTKY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 15:10:24 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECEA19BB;
        Wed,  7 Jun 2023 12:10:22 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-64d18d772bdso8536186b3a.3;
        Wed, 07 Jun 2023 12:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686165022; x=1688757022;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E/ROL5X23EtRW2s4Tc2qz2B6DotRTf9dy5BcCfiIbvU=;
        b=Z6emKV5sMX+Ncujj5Kz9JlORB4795EZHiSR0aRYUwa/TbvV8A7nxOXbKGrVAPxLpUP
         yqbZ32ptooRqyZTS+DlQqSyAS1RqGHa2KV0QwKz2yMtnVfgDYKaZUupyfmQ937NIb/kV
         4qiBAkDva8bdAYYTJpzTDu8vZbM+hreCBmdCD9RlqALEUmciE1CIOgUg7DksphazB2OX
         UdFBD1NGA7fLl072DO9PNuLjrLFPQYDNvR0E9puYR+rgcVn2yXII3wNcEWNZTwoeFfBP
         3hMNz95QBthWgsVBZTYdnOGgcbebBzE3LmPHQc49XlnZEY4SzN1vspxHrqlrjfrfSFQy
         4q0A==
X-Gm-Message-State: AC+VfDz7WpGhCL4eNw/Z041N5g1um1YpkFFGDBo+zujrfULGqdQd58JQ
        3wZczUKqgoujArY/iUFRAto=
X-Google-Smtp-Source: ACHHUZ5s6bXlj3C+bqupMuplRXRkw5rIJq4uiqcK2Z6KpTvD7jhCyPyY1gkYa2AQploVr2buS5ZutQ==
X-Received: by 2002:a17:902:b20f:b0:1b0:26f0:8778 with SMTP id t15-20020a170902b20f00b001b026f08778mr5337711plr.19.1686165021641;
        Wed, 07 Jun 2023 12:10:21 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id t6-20020a170902e84600b001aaf2172418sm1746216plg.95.2023.06.07.12.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 12:10:21 -0700 (PDT)
Message-ID: <34a3e242-cc79-908f-4382-30fac244676a@acm.org>
Date:   Wed, 7 Jun 2023 12:10:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3 3/8] scsi: merge scsi_internal_device_block() and
 device_block()
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
References: <20230607182249.22623-1-mwilck@suse.com>
 <20230607182249.22623-4-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230607182249.22623-4-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/23 11:22, mwilck@suse.com wrote:
> scsi_internal_device_block() is only called from device_block().
> Merge the two functions, and call the result scsi_device_block(),
> as the name device_block() is confusingly generic.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

