Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B839C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 18:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiKISmP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 13:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiKISmI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 13:42:08 -0500
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB1715734
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 10:42:07 -0800 (PST)
Received: by mail-pl1-f176.google.com with SMTP id io19so17904606plb.8
        for <linux-scsi@vger.kernel.org>; Wed, 09 Nov 2022 10:42:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sZbUA0kKUUmyGEId1uT+gWcT4FDqjHgasj25jCflKWQ=;
        b=EZbzGaJouYX70OVl+UzxWP5ra6MMEvGEmtyDdnDCRlurCuUWUW14kCZ+vCRzbffly7
         j1A4X42/GEgejA3C9YfgLMwJ4hK5IaMXJW4d03T8i6Et5fCYPzreKYCNsAaxfxmfuW/E
         F8O/DLi7i3UTwc2qQQXCQdtHJbtF544eBYw+eNhVhqRkiXIVNKboBVQEeHLqZvRSb2PR
         E0UfnCUbPxmnKzbHHSF/wey0gE/VlM2YXEvE7BEKMw/QLpODbMoGX8PNEuXN2tdKYJSY
         BCkwc095XBRIbxSknZyrxUJkrBfWxj0w4ITN7Rue5yY55/c7SBv2+XIBeqXutCDTLBet
         zapg==
X-Gm-Message-State: ACrzQf18Ay3HbSANCXc10TJUBDAQryrJDjRAkTyZVHTypbjHzu3Harfw
        /+IFhkicnOYqtNzycXScgRM=
X-Google-Smtp-Source: AMsMyM6F4mLhz+JhxbIoKdDrjgpokvlZeGQlxFFbLJhutKM/VqVYUSNSmW671sKDZxL0S/BX3O1arQ==
X-Received: by 2002:a17:90b:3646:b0:213:812c:7c62 with SMTP id nh6-20020a17090b364600b00213812c7c62mr71539807pjb.194.1668019326837;
        Wed, 09 Nov 2022 10:42:06 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:68b6:5dae:a00c:c3b? ([2620:15c:211:201:68b6:5dae:a00c:c3b])
        by smtp.gmail.com with ESMTPSA id d7-20020a170903230700b00172fad607b3sm9458416plh.207.2022.11.09.10.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 10:42:05 -0800 (PST)
Message-ID: <adf68613-e4df-457d-e9be-749f4838c07b@acm.org>
Date:   Wed, 9 Nov 2022 10:42:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v6 21/35] scsi: Have scsi-ml retry read_capacity_16 errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-22-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221104231927.9613-22-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/22 16:19, Mike Christie wrote:
> This has read_capacity_16 have scsi-ml retry errors instead of driving
> them itself.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

