Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854D9EB64D0
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 18:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238845AbjFMSWz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 14:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238913AbjFMSWy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 14:22:54 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8F51709
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jun 2023 11:22:52 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-651f2f38634so5882998b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jun 2023 11:22:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686680572; x=1689272572;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G5VgXM6sYRXu4WWCBU55bsPHcqdjZYxwo1hgv/LscC4=;
        b=Sm6M61o1b8OIqri0AM4mAaEznLCr51BwbaxSUhzipUcwaygtbILk6jTD5H9FZsL9Ip
         vyIhy8lud9WoJSF5Qr+1GyOvNE6jP9oovZjFC3soVP4jvIP/yc/l1taWu4HoiEKZMAFv
         qcvyNtzmgQ/oW8Io4EAvKJaNZCxIJSrQasiWyx2mhBlm8o62RwjZ9svLvSn5QrLpn89+
         DCS4VeFfS8/WGh6Hx9Belf5nC/37s9jEN+lxiCEuQ0b3d7lq0O7v/kDtCHJHsjm/4Mfh
         sCBMFna+8nePMR6yi/oxnsSp63//LoczHe/8AvkTWLWmVziLdzleMjDgnsFdHh1anNAj
         5bEw==
X-Gm-Message-State: AC+VfDxrUhHjs+LBmTL9BGR8orVKu9Osc/95/UcktCOMhRSUYemVpk7c
        UWh+9I8DU1x8JWP7Me843QBg8ivWDjg=
X-Google-Smtp-Source: ACHHUZ4tjCN0Dv2lUj1xoPujIAsBhxLTrlmJRRUkN5MubWez9X1qNYn8OBSVI4b3YdMXSzH7qBbm/g==
X-Received: by 2002:a05:6a00:21d0:b0:662:5146:c77a with SMTP id t16-20020a056a0021d000b006625146c77amr17398428pfj.31.1686680572142;
        Tue, 13 Jun 2023 11:22:52 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id a23-20020a62bd17000000b0062d859a33d1sm8918331pff.84.2023.06.13.11.22.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 11:22:51 -0700 (PDT)
Message-ID: <c3b42f98-31f8-39f4-4540-cccf0bfe31cd@acm.org>
Date:   Tue, 13 Jun 2023 11:22:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Arrow Lake
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org
References: <20230613170327.61186-1-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230613170327.61186-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/13/23 10:03, Adrian Hunter wrote:
> Add PCI ID to support Intel Arrow Lake, same as MTL.

The patch looks good to me but the "same as MTL" text in the patch 
description looks confusing to me?

Thanks,

Bart.
