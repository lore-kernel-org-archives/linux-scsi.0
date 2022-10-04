Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED54BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiJDWgb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiJDWga (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:36:30 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908206B8D2
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:36:29 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id d11so13881872pll.8
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:36:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NQnAmmz1j1kCpQJ2Md+DCctnqJz0WLbUaZcpqhtrrRA=;
        b=WYtT+4yc6ByZnk3kjfvtxvIbJOrzOIt0pGBLmfjxPddG6CDu+zV/rWx6+2Pk229cvJ
         lixPDPjy7xSyd7h9qYrwbbh3Rl7/A5khwAnTYzW/ZkwRSfgJWG36CLzc4oCdCQFcTW2A
         ouWe2tKbyQgPMfQP/0ks7pqZqPION+9d00ttWW+rIjejHhf6fgy77m33JOVpD3lYXqEx
         hM1/cam6O7JIRgTQ/rRtyxeca5LhlvOCs+wWUaXiHOiM58CwaRZ9ydUTpOl3umA3a3b5
         yqp8pdgTOQtlbD58RoRRHmwD7iRccitnQ98kRlTrTUDjCEXMg9z0Y66JLwaEOmZehsQ1
         5JHQ==
X-Gm-Message-State: ACrzQf1LyxkJnykGXU7wCq9l5gaBKn7gRKtBHn4FhjWRAa0LVDHNXOv8
        FguzYaGI2sZ97F5RoLWohQk=
X-Google-Smtp-Source: AMsMyM5iBqgiorIVo3B1KrxZXmQeH8pK3gPfTi1S1PhVxo5q4RQ5aPXKldmm+dzTKBTWv98U++nDLA==
X-Received: by 2002:a17:90b:3505:b0:203:b7b1:2bc3 with SMTP id ls5-20020a17090b350500b00203b7b12bc3mr1927621pjb.242.1664922989043;
        Tue, 04 Oct 2022 15:36:29 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id v6-20020aa799c6000000b005621152c051sm287025pfi.66.2022.10.04.15.36.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:36:28 -0700 (PDT)
Message-ID: <4cca51e0-9322-9679-2328-d54234a99d3f@acm.org>
Date:   Tue, 4 Oct 2022 15:36:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 09/35] scsi: core: Convert to scsi_exec_req
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-10-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-10-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:52, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert to scsi_exec_req so
> we pass all args in a scsi_exec_args struct.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
