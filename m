Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF4AC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 14:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiJQOYS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 10:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJQOYQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 10:24:16 -0400
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4892750075;
        Mon, 17 Oct 2022 07:24:16 -0700 (PDT)
Received: by mail-pg1-f173.google.com with SMTP id r18so10561747pgr.12;
        Mon, 17 Oct 2022 07:24:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YOWQPj7s2AYnh0bbb2ZlObjp2FI+P4uR59L0NFrNxN0=;
        b=mJ2wsM2dXyJGtA+pMLH768i/R5ISfLq51rSmBWEcPydL03jrj8ZsGzk6XRSzFOLWCw
         4K5rz5MGxXIQNavkpL7I1s7+H51g3bXTWUmJ1imo+wPIIXmDrutpO49Zvyl96yfQUgFS
         r103oBHMiVtjcYMsKn48jxeLmsXA3qp5jr093mpdql8IOR0E/k1+TDvwTXJkElN04LdY
         uYIQRy2MYGZtO4U1nUsnoqAHT8T+t8PH71/4ACX+YLICh+rYdb+p0HLl8t9TgGkdobf7
         S2I39O4n6IxURQYt6lUuGmz0foZzniUCElrAtwzcYO+DWnyXLgl1aC3WzsvzfBzX7ODa
         KdXg==
X-Gm-Message-State: ACrzQf2YXIkdRTDY2T2rEvFa3wynTElq3oxQK7ZmwTsf2XR1/4KzFFfJ
        iFHDKw18TSpSZybvwjEFnEU=
X-Google-Smtp-Source: AMsMyM62BMZRM35vb/QAjC2I1HUzBMIGyJUnIvmlJ1E+yrG33DpbWVg6wUxyM6L4BDJDEh0x8YTnWA==
X-Received: by 2002:a63:ed07:0:b0:442:87:3a38 with SMTP id d7-20020a63ed07000000b0044200873a38mr11146726pgi.216.1666016655753;
        Mon, 17 Oct 2022 07:24:15 -0700 (PDT)
Received: from [192.168.50.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id b14-20020a170903228e00b00176e8f85147sm6721330plh.83.2022.10.17.07.24.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 07:24:14 -0700 (PDT)
Message-ID: <8377d820-c22a-0405-a693-7872cd1961a4@acm.org>
Date:   Mon, 17 Oct 2022 07:24:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] scsi: ufs: core: Fix typo for register name in comments
Content-Language: en-US
To:     keosung.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CGME20221017095815epcms2p110e3421b99bb9a937620b4d065d0ed12@epcms2p1>
 <20221017095815epcms2p110e3421b99bb9a937620b4d065d0ed12@epcms2p1>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221017095815epcms2p110e3421b99bb9a937620b4d065d0ed12@epcms2p1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/17/22 02:58, Keoseong Park wrote:
> Change "UTRMLCLR" to "UTMRLCLR".
> The meaning is "UTP Task Management Request List CLear Register"

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
