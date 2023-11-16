Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14161C54FB9
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 15:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjKPPkd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 10:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjKPPkc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 10:40:32 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C0318B;
        Thu, 16 Nov 2023 07:40:29 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1cc68c1fac2so8744045ad.0;
        Thu, 16 Nov 2023 07:40:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700149229; x=1700754029;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S1xEO5MYelACJVsJ4H6pwDtv3cXRTLIOXgC9CSDPEQk=;
        b=fDU1/zPPxKn5qicdrQ4v+ma8HHEXK29y/CwONUESZ/ZusaqN6wCx6TAJZfDRO7Vjnt
         gqFxrnlHjliw0q1v3OixaZhnGRJvFVZ0D5V3He+14pOtqQEb1GDIxHi5f9FXewRlbPoz
         GXSDtGNAXp/eEomA1Bg2J7gnmDf1qDe6ewdkKaJiLrzDBau18blZ1Bqv47pu7MwPFTwH
         RX+PY4/6sCjhfbvq+X6DPdYOAQn+cvzRFTzi5cVNszNAhi6v6IFDVAL1gy+0Q83QHzNG
         h+7elFsPKFiCM0FmbQKaS2Di1LEhMrXgQ+K8ZJHXpV06EHYI81UppUCLHwKLw30JoQL3
         kM6w==
X-Gm-Message-State: AOJu0YwP66UQZNPvTcQrFY5y31Fpbr78NotQ2Wfj5/p0R2hTqJ0qC/x7
        +JJuio8C4KvqcOZz8q3urpE=
X-Google-Smtp-Source: AGHT+IFnxCAdrAhgyQ7GBItotGlUi3W1GVkooDSX3heWLobAARQE1dsZUTt8pupZqsdGxWzhy+Oqdw==
X-Received: by 2002:a17:902:e543:b0:1cc:4146:9ecb with SMTP id n3-20020a170902e54300b001cc41469ecbmr10060719plf.47.1700149228811;
        Thu, 16 Nov 2023 07:40:28 -0800 (PST)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id s14-20020a170902ea0e00b001cc2c6cc39asm9357113plg.243.2023.11.16.07.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Nov 2023 07:40:28 -0800 (PST)
Message-ID: <c29c90e1-903d-47de-89b1-af81195843a7@acm.org>
Date:   Thu, 16 Nov 2023 07:40:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: mediatek: Change the maintainer for
 MediaTek UFS hooks
Content-Language: en-US
To:     Stanley Jhu <chu.stanley@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, peter.wang@gmail.com
Cc:     matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com
References: <20231116024744.10795-1-chu.stanley@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231116024744.10795-1-chu.stanley@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/15/23 18:47, Stanley Jhu wrote:
> Change the maintainer of MediaTek UFS hooks to Peter Wang.
> In the meantime, Stanley has been assigned as the reviewer.
> 
> The original maintainer, Stanley Chu, who can be reached at
> stanley.chu@mediatek.com, has left MediaTek,
> so please update the email address accordingly.
> 
> Signed-off-by: Stanley Jhu <chu.stanley@gmail.com>

I think patches that update maintainer entries should Cc the email
address that is removed, in this case (I know this email address is
now invalid):

Cc: Stanley Chu <stanley.chu@mediatek.com>

Thanks,

Bart.
