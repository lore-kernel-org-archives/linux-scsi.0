Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B10FCD4846
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 16:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjIVQtA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 12:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjIVQs7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 12:48:59 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C170A3;
        Fri, 22 Sep 2023 09:48:54 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1c5cd27b1acso20759435ad.2;
        Fri, 22 Sep 2023 09:48:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695401334; x=1696006134;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+sCtmUDBpMdQToR/DyB7RUeFeznfo3qoIbLHmjCgR+o=;
        b=OMMB983VQ4Ri6WGkm4Xcvi0Oth2YqTPhqA0qiGquBBQBz+fgJullM21yng9ec4VpZT
         kD4/NhAZIAPDhCErVhfvJW/DKxXCMAOUKLXdfIs5q8+T5SWeMZMyeLqxT/v75twV/NmK
         A/MHCOl6TgWlUyxp+wU8ua9ZlhlxEEoGNTwxCu+uBw3rvnpKcYU4R+gfA8+Zp3p0RpgM
         BEGnLHLE4GnddkmQM7K3eDnDPdpaMA5w/hZYvlLaIYKo9dUl60zfAkeMmPjAx+ySHueU
         y4YVFM0PTojPzP6P1WEcl2Vz9bsch999hDQ7jDfevO6BBnapo8Y+QXTf4b3NARIAWy2Y
         QRmw==
X-Gm-Message-State: AOJu0YynEvIl6s09d+QGitnztN1N+ZRpgfTVTbuiVBDlRH0QOPjMvjui
        mthzwa0uxpNNxKTjkxVcGWk=
X-Google-Smtp-Source: AGHT+IF7v4Y3Ey+OCjhUfSF6WS2EQmgIILzA53OrZwiMExoahDTwm8GARrOq8OwTSmfdqwnLoNt1+w==
X-Received: by 2002:a17:902:70c9:b0:1b8:6cae:3570 with SMTP id l9-20020a17090270c900b001b86cae3570mr52861plt.11.1695401333696;
        Fri, 22 Sep 2023 09:48:53 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:70e9:c86f:4352:fcc? ([2620:15c:211:201:70e9:c86f:4352:fcc])
        by smtp.gmail.com with ESMTPSA id ji20-20020a170903325400b001bdc2fdcf7esm3711979plb.129.2023.09.22.09.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 09:48:53 -0700 (PDT)
Message-ID: <2d8cc4f2-12b9-4067-b102-74d2c2a13057@acm.org>
Date:   Fri, 22 Sep 2023 09:48:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/3] scsi: arcmsr: support Areca ARC-1688 Raid
 controller
Content-Language: en-US
To:     ching Huang <ching2048@areca.com.tw>, martin.petersen@oracle.com,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <5445094045757819ea650b138a8e03d833e2cbfc.camel@areca.com.tw>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5445094045757819ea650b138a8e03d833e2cbfc.camel@areca.com.tw>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/23 01:09, ching Huang wrote:
> The following patches are made over mkp's 6.7/scsi-staging
> 
> This series add supporting new Raid and new PCI device ID controllers
> - support new Raid controller ARC-1688
> - support new PCI device ID 1883 and 1886
> - updated driver's version to v1.51.00.14-20230915

Please set sendemail.thread = true in your ~/.gitconfig file such that
the patches appear as replies to the cover letter. I'm not sure whether
how this series has been posted is compatible with the workflow of the
SCSI maintainer.

Thanks,

Bart.
