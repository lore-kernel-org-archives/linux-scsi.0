Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55164EB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 22:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbjF1WwW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 18:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjF1WwS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 18:52:18 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7447710F8;
        Wed, 28 Jun 2023 15:52:17 -0700 (PDT)
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6b71cdb47e1so42178a34.2;
        Wed, 28 Jun 2023 15:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687992737; x=1690584737;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cvtCI5+3q5/G6rYWhHkCsWUUU9M4PgrZlvCGqZLiWyE=;
        b=R7PNbVX6pxRIzD5hdPa7Gt8Fv87/+urutX227UEIdvpJZmD9sY4tle52YtTCLMtDfG
         TqoX5TnXIfKEAaUDyItgDUOYSE2ZWrRfxn5uhdSm6oS/bvJ1tNFNYnMUb69dMF0yiMhY
         TCHoN/Hpug83geFlNlw3JCbW799xdI741vKeQPnfOlu6ShBS5bexzPbh26/xrpjKmUnP
         ylXoCC1QTpls8DvmGLCskHq4qr3XuCmM0gzVJl/lS1MWA4vpNqeyRvtO8R3D1n4ebiSs
         EwZ6TFs7BiXWem5m7xaOVJKl2P+VzPZR/CC13wMNgbq+a6099rORCMZ9pB4xWQAs6ebc
         Xhfg==
X-Gm-Message-State: AC+VfDzDWixzySohgqAzp2jtBFCP0LJQQWsnwojlQ3o08RAl/zpkVYMB
        CUtDUngUPZFUSNZwx5uHtf4=
X-Google-Smtp-Source: ACHHUZ5OHNevUXjXpu164KeoHuSOe9UTv06gyX2dL9aHD+vK3+AfD3GOwxgC5XuIgbtdsa8JHp5LBw==
X-Received: by 2002:a05:6358:edc:b0:12b:c378:b090 with SMTP id 28-20020a0563580edc00b0012bc378b090mr26702169rwh.26.1687992736525;
        Wed, 28 Jun 2023 15:52:16 -0700 (PDT)
Received: from [192.168.50.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id y17-20020a63e251000000b005501b24b1c9sm7798360pgj.62.2023.06.28.15.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 15:52:15 -0700 (PDT)
Message-ID: <f15e3da4-e555-a5c3-b42c-ece860aae3cb@acm.org>
Date:   Wed, 28 Jun 2023 15:52:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] scsi: ufs: Remove unused function declaration
Content-Language: en-US
To:     keosung.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "mani@kernel.org" <mani@kernel.org>,
        "quic_asutoshd@quicinc.com" <quic_asutoshd@quicinc.com>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "Arthur.Simchaev@wdc.com" <Arthur.Simchaev@wdc.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CGME20230627012931epcms2p76f458e0b2ce8a591b56bbcc6a2f1a3bb@epcms2p7>
 <20230627012931epcms2p76f458e0b2ce8a591b56bbcc6a2f1a3bb@epcms2p7>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230627012931epcms2p76f458e0b2ce8a591b56bbcc6a2f1a3bb@epcms2p7>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/26/23 18:29, Keoseong Park wrote:
> Commit 2468da61ea09 ("scsi: ufs: core: mcq: Configure operation and
> runtime interface") added ufshcd_mcq_select_mcq_mode(), but
> it's not used anywhere. So remove it.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
