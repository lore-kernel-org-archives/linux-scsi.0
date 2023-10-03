Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36EDFE7AD77
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 17:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjJCRdH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjJCRdH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 13:33:07 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD649B
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 10:33:03 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1c737d61a00so9129765ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 03 Oct 2023 10:33:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696354383; x=1696959183;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BWCN+1/RHJHLFNfBft8vz420yOQoDHFC9NfHBYuie5s=;
        b=cCTwsqIXTSiHwRRMD40XP9QajQzODjgWki5iVFFu5XQW3fcTxJX8ryiqDEJhuvJXcV
         G2e9SB4ScO6kKo7msNdXEC496Vu0ruDpPrNC/QsK5JcroTsQBhoj78SkSVm1buox24tP
         nh60yDwXg3GmHBpmnL+NOV4khxQ+IWuuWZU/pJYVD3GFNmHWoihoSZF66hsgboet6dbK
         /0LKJUX9XVFtrJ6sKvUkA2f9tWzt5Bq39eKNqABvjeXDI4aopZfsyI+J6Xp1DJoiXuN+
         /co9t6xFgUcTxMW0YB7s4T7IqBSLVGVMbrs8kI0zehjURqhs9LcHBt4v+Qh03XAz1GRJ
         D2Ow==
X-Gm-Message-State: AOJu0YwBm5wuYxNju3SKnyRvO0y5kVJz9Xxrmps/MdSYpOADYySxzKY9
        L4mbQLOztHIYrz7fI/qFEIQ=
X-Google-Smtp-Source: AGHT+IGv5jC3MOIOSNZ1QnWwB0M+CoGI5JoM5EqdFmHg4ENSSlKnNyyo/QP8/kwTz4jNA3ez4KSibQ==
X-Received: by 2002:a17:902:c945:b0:1c7:4ab6:b3b7 with SMTP id i5-20020a170902c94500b001c74ab6b3b7mr209529pla.67.1696354382998;
        Tue, 03 Oct 2023 10:33:02 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:fc96:5ba7:a6f5:b187? ([2620:15c:211:201:fc96:5ba7:a6f5:b187])
        by smtp.gmail.com with ESMTPSA id jf1-20020a170903268100b001bc18e579aesm1867170plb.101.2023.10.03.10.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 10:33:02 -0700 (PDT)
Message-ID: <c7052e80-3602-469b-8095-ab0eb40e010a@acm.org>
Date:   Tue, 3 Oct 2023 10:33:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] scsi: Use Scsi_Host as argument for
 eh_host_reset_handler
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20231002155915.109359-1-hare@suse.de>
 <20231002155915.109359-2-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231002155915.109359-2-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/23 08:59, Hannes Reinecke wrote:
> +	if ((hd = shost_priv(sh)) == NULL){
> +		printk(KERN_ERR MYNAM ": host reset: Can't locate host!\n");
>   		return FAILED;
>   	}

In the above example and in multiple other cases formatting does not
follow the kernel coding style. Please consider to run git clang-format
HEAD^ on this patch. Otherwise this patch looks good to me.

Thanks,

Bart.

