Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF3DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 18:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbiBVSdt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 13:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbiBVSdl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 13:33:41 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9C9171841;
        Tue, 22 Feb 2022 10:33:07 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id ay3so7551203plb.1;
        Tue, 22 Feb 2022 10:33:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9sjZqsZYm/eIw1QilXw043tBBHAHe7duB8HAHszrVGw=;
        b=f2Yh87p9fP2PPmNupD0Vj74xYgoC+uBcICEwN8j2qDoZtMQZv51jJJb3pixdcPm8Lo
         ZY/XxnCZKFLEUeWiCF9UQhUFFR7XG03aziopWsJZGjmy6jmUtVmR3j1qG2+hyJNmm3Nf
         30BpBigylvFLRl7e5Q4w3M9N3mYBPvJcbWO5NpRDe7kB0O5g+AsvckIj9rz7EGWs1FO6
         TdPGX7zMumZaEleqXCOabBU90hV5u5aSFiiK04RtvFzeE8jHrrZef+8jJE3vYhPco22o
         2pFTEbS3BgSJJA+9ozWnYVBbPgwxop0tgVvhtaX16ZEkKLv7oWh+PUtfdmqMZuIe2xtJ
         dYEA==
X-Gm-Message-State: AOAM533Wa5y1yyIRO7Ghq/qGkF4dgIrmUNrtMARQvvZFBlWR5VYcxzzv
        ErU+uYGMaFmPyR2+DejgurmTMRO2ZAVAJA==
X-Google-Smtp-Source: ABdhPJyceFrq8zshYNrqHnAVeV68WpNGp0VZ7u6cgcyBOPOSqdmhZ0xndpx8aHmPCMCc2nbGfMwL3g==
X-Received: by 2002:a17:902:9a8e:b0:14d:ae35:19f9 with SMTP id w14-20020a1709029a8e00b0014dae3519f9mr24133142plp.66.1645554787177;
        Tue, 22 Feb 2022 10:33:07 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id v23-20020a17090a521700b001bbfc181c93sm225378pjh.19.2022.02.22.10.33.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 10:33:06 -0800 (PST)
Message-ID: <7873b73b-c2ee-81b2-4b70-690ad62037e5@acm.org>
Date:   Tue, 22 Feb 2022 10:33:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 1/8] bsg: don't include scsi_request.h in bsg-lib.h
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220222140443.589882-1-hch@lst.de>
 <20220222140443.589882-2-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220222140443.589882-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/22/22 06:04, Christoph Hellwig wrote:
> There is no need for any of the information from scsi_request.h in
> bsg-lib.h.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
