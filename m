Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C467C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 17:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356760AbiELRS1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 13:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346013AbiELRS0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 13:18:26 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A9D269EF6
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 10:18:24 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id h186so2544517pgc.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 10:18:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=ZiCZca+nUKcYiBD4TTZLtTYTiykRydRfKBl7Jk8F1gs=;
        b=vBsHLcFvmn88Uos05nfQkXcRtOzGo4YHbFk4o+V+OqNwuEhxFF+Tui1lw/NufPkAen
         y3Y1bzqvaZlqpA8bRiHc6L6WSqy+O+5ZD+xXMS3fv5x/SA7C70Au9Pm8J+p187Td9arE
         R6TM9VQ1aTa6OZU4HhlNmMXRxrBcj0nGza9LNDufLEwoLbyDWP9/7DaHePLqonFfal+Z
         7xZQl9T98sUkm+EdyOiJ6V0RA+pyGuHCJsev5DiyArZazdcGo+yXZd8Qr6bxmkLfiKCd
         1NdwRxtBKN5Z6ddq4OVtJpZH7AJKqt17FtLxqb2a3gUXPrDSUl7k0/+RJNuWa2zxMacK
         Nebw==
X-Gm-Message-State: AOAM533WMCUAoyUCxFozWjEszhV9jpnRJlxSg8iUgwP/MOCsTtyDMVL/
        vlvuC7YfLNylqtcNM3xXvG2JmH9NFAI=
X-Google-Smtp-Source: ABdhPJxovUfYbpzl/iA9ASg8gh9Kn6CNmSPacpkPFb1FUMEXSq4WDlr6Bh7WBwz5WDpcyifN5RFjsw==
X-Received: by 2002:a65:48c5:0:b0:3c5:fe30:75dd with SMTP id o5-20020a6548c5000000b003c5fe3075ddmr515356pgs.269.1652375903002;
        Thu, 12 May 2022 10:18:23 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:78c5:5d65:4254:a5e? ([2620:15c:211:201:78c5:5d65:4254:a5e])
        by smtp.gmail.com with ESMTPSA id e3-20020a170902784300b0015edc07dcf3sm194309pln.21.2022.05.12.10.18.21
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 10:18:22 -0700 (PDT)
Message-ID: <47618ef6-ef71-b6a2-eb1c-072b7d59748d@acm.org>
Date:   Thu, 12 May 2022 10:18:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: ufs: Split the drivers/scsi/ufs directory
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20220511212552.655341-1-bvanassche@acm.org>
 <202205122323.RcDb4pBm-lkp@intel.com>
Content-Language: en-US
In-Reply-To: <202205122323.RcDb4pBm-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/12/22 08:59, kernel test robot wrote:
> All warnings (new ones prefixed by >>):
> 
>>> drivers/ufs/host/tc-dwc-g210-pltfrm.c:36:34: warning: unused variable 'tc_dwc_g210_pltfm_match' [-Wunused-const-variable]
>     static const struct of_device_id tc_dwc_g210_pltfm_match[] = {
>                                      ^
>     1 warning generated.

Regarding the three warnings reported for this patch: I consider the 
issues from these reports as out of scope for this patch since this 
patch only moves code around and the reported issues have been 
introduced a long time ago.

Thanks,

Bart.


