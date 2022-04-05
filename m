Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D945C43217
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 01:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444251AbiDFBIi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573493AbiDETMQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 15:12:16 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8482CE885A
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 12:10:17 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id j20-20020a17090ae61400b001ca9553d073so381251pjy.5
        for <linux-scsi@vger.kernel.org>; Tue, 05 Apr 2022 12:10:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Fet2Y0pc42l71C6v5/CIx56hIjYz7npI2Z55ri03CoU=;
        b=q9yV9b6cny7G5YUWTlMXM8yGPH3Wy/X9MBR0MNKvznhH3bG/AYfg309/IJWoUvPmbJ
         Ca3R/iO6UZrRvXjItwsLPqI3wnooVXUioTP2tI3mNG8x/y2NmQawydlDj0juAg+ilOP7
         WQRDMfzSiKCQsNHsJCFmLgTOl8jw2152H+wu+KhR8eLWvDyNOsa+EhiwPZN46ExxYIWk
         Z3YVCseDKRccF+1/dn+iCRWg7tQDR3jh05ZwmyekWdb/OR+hG6okMVXIDqJYvo8vJUxZ
         t2Wx4PLhADeH44CgudfmZ/mplEJLyIfpqeTOglShKMk/1Ug4Iyy0xgH/6zAUGx2ogxjP
         qafg==
X-Gm-Message-State: AOAM531bRVYA7zNbUc6AU+6+RfYDUjJlAICxnL/sG53HNMuGaWivoqyN
        a8+0VOc3UJLp8OpV77y3UmQIi6DLLQI=
X-Google-Smtp-Source: ABdhPJykFe0uDmmXCylomDUYmPy/HtYfh5RZyhLp974W/xWDbuPccWSEfDG5x2j0DFBgePEwZFmV2A==
X-Received: by 2002:a17:902:a98a:b0:155:fc0b:f1a with SMTP id bh10-20020a170902a98a00b00155fc0b0f1amr4839293plb.21.1649185816942;
        Tue, 05 Apr 2022 12:10:16 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm16608283pfc.78.2022.04.05.12.10.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 12:10:16 -0700 (PDT)
Message-ID: <3db47c02-1514-f0e5-0929-857547697ff8@acm.org>
Date:   Tue, 5 Apr 2022 12:10:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel MTL
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>, linux-scsi@vger.kernel.org
References: <20220404055038.2208051-1-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220404055038.2208051-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/3/22 22:50, Adrian Hunter wrote:
> Add PCI ID and callbacks to support Intel Meteor Lake (MTL).
> 
> Cc: stable@vger.kernel.org # v5.15+
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
