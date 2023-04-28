Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34721C77B60
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 16:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjD1Q66 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 12:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjD1Q65 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 12:58:57 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265CB35B8
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 09:58:56 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-63b70f0b320so280609b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 09:58:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682701135; x=1685293135;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rMRHBaCfiwBiLID+WN+drl9fx/ervVwZ3OGSOFqOfls=;
        b=d3QOHMPe8wNlb22aHxdwN4fggbmAP96LmZpJkwrUDcsMuF3sjNXVlQHjNTXx8tBZ6+
         tTbE0PpgdI7bDNR+2oanc1L0km8INQr1bFQ6wa4hQqyaVobLvlHaMgipPrpaWAiwDY4x
         0wmviF4rdrG3Y5CSaG4Rdv58gM1QtAzAfdtpw2bQxR1+a4g097FIq3aIevcQBwwG89XF
         XOjIqdqrY9m7oKMygTtB8LFzQQFmbFQs81RxygUkiFc7GZRDJqBUB335K5KoMJjlm+wu
         D59bQrwUiH3K3OLdaEil16QLpVdBnSi85YJOafenzuJB1ry2KPVbdmTnTwtwFS9cZLyD
         5Qfw==
X-Gm-Message-State: AC+VfDyZVxIzWWqA6sv0bmfnwOasIdK3D+7xW8JtBewsTZZxc+Mh2i89
        R3oU7dLvyd9AYHZxVGxiG64=
X-Google-Smtp-Source: ACHHUZ6VgsK0dXIoqDhaXwkHEXr4U9vi30oiyDxFmQ3g/Y9PdrkzPrUOvoS0xigeQWioPkrnfMh5Yw==
X-Received: by 2002:a05:6a00:a26:b0:641:3c61:db27 with SMTP id p38-20020a056a000a2600b006413c61db27mr1897810pfh.13.1682701135518;
        Fri, 28 Apr 2023 09:58:55 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id fc2-20020a056a002e0200b0062d859a33d1sm15424423pfb.84.2023.04.28.09.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 09:58:55 -0700 (PDT)
Message-ID: <8c7c38df-8914-4137-c0d2-fe8be8b3ec5a@acm.org>
Date:   Fri, 28 Apr 2023 09:58:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 2/4] scsi: core: Update a source code comment
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230425233446.1231000-1-bvanassche@acm.org>
 <20230425233446.1231000-3-bvanassche@acm.org> <20230428053817.GB8549@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230428053817.GB8549@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/27/23 22:38, Christoph Hellwig wrote:
> Hi Bart, this is the first patch of the series I'm seeing in my
> inbox.  It seems like patch 1 and the cover letter got lost,
> making a useful review impossible.

Hi Christoph,

I will Cc you on the entire patch series when I repost it.

Bart.
