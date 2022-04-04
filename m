Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52DFC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 02:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358063AbiDDCJ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Apr 2022 22:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235878AbiDDCJZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2022 22:09:25 -0400
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B162E0AA
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 19:07:30 -0700 (PDT)
Received: by mail-pf1-f177.google.com with SMTP id 7so613392pfu.13
        for <linux-scsi@vger.kernel.org>; Sun, 03 Apr 2022 19:07:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=frfg7wG3wzGB+f8K70AHhJNIrFlEXBun2rTsIvwKaJM=;
        b=0D5ExCxJBJNLYS3Bm9AYIw3PMjaX/P0AuGO2ynGRJR6lLb9/WqNtLuiTMKZG0PfTQ2
         dKuWooJ5F+0aQSBv6lgT2TdgqV/sggxXgOBMZhi/N9fp96gnBxzQ/9jfcPpIZPmTy9He
         Mi90aNZ9Fi+1w19KRogxRVkXfTBokYulEWIzfWoOIS98GhiEhGANLBU7oHQZOzeSdBXC
         Rrp/1AFGsJ0sBWLWmYAn8a6b1kOh9hFs7c9F+vyk5xM6o98O19Pq/zUTpCOcV9aen+0e
         q0l9VV3O4tfg5Fn4nR1sP8eDfir0sFfedVTaBHQb+JlAalwpnfLCXKfi2+ObBZdxfRUx
         bZ1A==
X-Gm-Message-State: AOAM531d/6HI/pnCAu1dOq2AhbMwy6oRDRsmL+SP3PBlUXvHW8uk8mx1
        Hm+wf2tuSlsQe74/S1AJaz4=
X-Google-Smtp-Source: ABdhPJyU48/ALTj2v9SVmIIr+oQy//iXcMkXCtwR+1MldXMnPgMHXtGgRCxXM3plUkcEuoBpDRN4wg==
X-Received: by 2002:a63:f95f:0:b0:398:cdd5:b18 with SMTP id q31-20020a63f95f000000b00398cdd50b18mr14410799pgk.562.1649038049589;
        Sun, 03 Apr 2022 19:07:29 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id d5-20020a056a0010c500b004faee9887ccsm9861237pfu.64.2022.04.03.19.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Apr 2022 19:07:28 -0700 (PDT)
Message-ID: <4d6c2e51-b8d7-6f2b-bcd6-a26d60a21fce@acm.org>
Date:   Sun, 3 Apr 2022 19:07:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 11/29] scsi: ufs: Remove unused constants and code
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Stanley Chu <stanley.chu@mediatek.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-12-bvanassche@acm.org>
 <DM6PR04MB6575F371F794F5AA28FCCB33FCE39@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575F371F794F5AA28FCCB33FCE39@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/1/22 23:59, Avri Altman wrote:
>>
>> Commit 5b44a07b6bb2 ("scsi: ufs: Remove pre-defined initial voltage values
>> of device power") removed the code that uses the UFS_VREG_VCC* constants
>> and also the code that sets the min_uV and max_uV member variables. Hence
>> also remove these constants and that member variable.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Looks fine to me, but better get an ack from Stanley,
> because he specifically wrote in his commit log:
> "...
> Note that we keep struct ufs_vreg unchanged. This allows vendors to
>      configure proper min_uV and max_uV of any regulators to make
>      regulator_set_voltage() works during regulator toggling flow in the
>      future. Without specific vendor configurations, min_uV and max_uV will be
>      NULL by default and UFS core driver will enable or disable the regulator
>      only without adjusting its voltage.
> ..."

(+Stanley)

Hi Stanley,

Can you take a look at this patch?

Thanks,

Bart.

