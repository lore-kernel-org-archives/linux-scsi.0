Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 108A5C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 19:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbhKXTtn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 14:49:43 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:36822 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235610AbhKXTtn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Nov 2021 14:49:43 -0500
Received: by mail-pl1-f179.google.com with SMTP id u11so2738639plf.3
        for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2021 11:46:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CdUmT6OKnaCclKBXLpK3apCGXB8IvS+Y0N/0/fweDWc=;
        b=0RGB/D4HX4Bm95bhUl6AIQDdNF86X4vLKg80Brbeyzv9yyAGYztsE05StP2HM4TwNo
         RqmltxkMh5c/KNEd7feN0oGCehmgBGm/GWlLfeqgPXIZpO+GgSNmCnXUmKsHUK8u7NCU
         fGIZUhqNivMonywW99Cox4hbTmHUqr2n6fFn9P53XdFtNlmNcxSC/uyCdeA9TSzElStO
         Pw4jqdbSiTIrTByBF1rNwtiIQCPtvpdswH80l5nY2RmPUQBdC1Z36WQJqNS5Ge3IFUGY
         BJuzWSxXh9jyCui2k0KCigxvpvwLlg0A5J6WT/BRYopJauqqGwKs2M1eFtwI0qKaiKD/
         Rxrw==
X-Gm-Message-State: AOAM5324MDIhKjfF1KbyEjYEOiNp6mX5TvposiOPf3nyi7jKfKf72J32
        S98ayJC2JHhg1r60vZoXWvlF0nfsbvg=
X-Google-Smtp-Source: ABdhPJwgoTLZDj96jlQanKt38y6OfhnLHjprQANSOpCCU+KpFkva70X4BjUVrIE9EBH3n+0Mz8IbRQ==
X-Received: by 2002:a17:90a:ce14:: with SMTP id f20mr18342307pju.121.1637783192753;
        Wed, 24 Nov 2021 11:46:32 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t3sm565262pfg.94.2021.11.24.11.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 11:46:32 -0800 (PST)
Message-ID: <e2b6721c-b8bd-9725-7fe3-24d4ffd36e86@acm.org>
Date:   Wed, 24 Nov 2021 11:46:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel ADL
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>, linux-scsi@vger.kernel.org
References: <20211124091713.1723917-1-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211124091713.1723917-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/24/21 01:17, Adrian Hunter wrote:
> Add PCI ID and callbacks to support Intel ADL.

Does "ADL" stand for "Alter Lake"? Mentioning this in the patch 
description would be welcome.

Thanks,

Bart.
