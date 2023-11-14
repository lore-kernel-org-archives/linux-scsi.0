Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA04C4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 17:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbjKNRsI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 12:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbjKNRsG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 12:48:06 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC1A94
        for <linux-scsi@vger.kernel.org>; Tue, 14 Nov 2023 09:48:03 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-28037d046b0so4852426a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Nov 2023 09:48:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699984082; x=1700588882;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wbdtdxjZsY+qiR58ZfbzP84BJG4e2rozaQ5edD09vZY=;
        b=RY/tIsuqI8Om40Vn2vHpf7jvU2ER3iQur3NM/LTYXjKd5t4hWUN7kE1kkiSqMdijwp
         Ea0u32Q+erikoQGyP5LGtDFDm6NtOPd7wTkxofy/2EUyhc+yyPy+u/WIRqfhtdkEbNDZ
         KFzQdcN2IlxZbNfNQguGk+gyW3lYGQahCNOMRkfam1A8YZeNm3IyhkTnzn5ldS+x5sDg
         vbj4zzRJDcfROj6tvRownCNDfEs7gP2IK1WYZscRkgfeHYcJPr+ji5WPAxqR/nehj9tI
         UIceIARomKMb4dw5yQvKjYFIXKonMLUDJOKueDDGX/ofxU2I/45ykg43unSv5Uh5iFsB
         TaoQ==
X-Gm-Message-State: AOJu0Ywj2bQuqci8JTh2TDKDTSEKGyhr00/rNi52qxHELVZri/cXn583
        I+e7tqk9FRF982b+37LZF1I=
X-Google-Smtp-Source: AGHT+IEFYxhO4JK/Jbab+IKdJFeZEWuFPgbCMVvkixBW41T5+cJ8zLA9DlG6qLXGSIW78tzZC9vE6A==
X-Received: by 2002:a17:90b:1e46:b0:280:2840:80bd with SMTP id pi6-20020a17090b1e4600b00280284080bdmr6257288pjb.49.1699984082336;
        Tue, 14 Nov 2023 09:48:02 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:2278:ad72:cefb:4d49? ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id 20-20020a17090a035400b00263b9e75aecsm6188098pjf.41.2023.11.14.09.48.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Nov 2023 09:48:01 -0800 (PST)
Message-ID: <64b34b82-f442-4f64-a515-7df327260a48@acm.org>
Date:   Tue, 14 Nov 2023 09:47:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers: fix typo in drivers/scsi/st.c
Content-Language: en-US
To:     zilong zhang <NeoPerceval@outlook.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, trivial@kernel.org
References: <SEYPR03MB6507111C9AF0BBE744EA7841A2B2A@SEYPR03MB6507.apcprd03.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <SEYPR03MB6507111C9AF0BBE744EA7841A2B2A@SEYPR03MB6507.apcprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/13/23 06:33, zilong zhang wrote:
> Replace invisible character with a space.
> The diff looks like this on my terminal:
> 
> -^L
> +
> 
> Signed-off-by: zilong zhang <NeoPerceval@outlook.com>
> ---
>   drivers/scsi/st.c | 30 +++++++++++++++---------------
>   1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 338aa8c42968..19d86257036d 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -230,7 +230,7 @@ static DEFINE_SPINLOCK(st_use_lock);
>   static DEFINE_IDR(st_index_idr);
>   
>   
> -
> +

The patch subject is wrong. As Steffen pointed out, the form feeds are
intentional. Additionally, the above changes do not follow the Linux kernel
coding style. One blank line is sufficient to separate function definitions.

Thanks,

Bart.
