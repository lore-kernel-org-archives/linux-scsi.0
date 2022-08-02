Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69050C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 17:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbiHBR1X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 13:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiHBR1W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 13:27:22 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D70727B1D;
        Tue,  2 Aug 2022 10:27:21 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id iw1so14079511plb.6;
        Tue, 02 Aug 2022 10:27:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=FBQBYdq0tq0+O20K9TQ9gOtYIGTjRXY3aphbH6sppHU=;
        b=fkDqZ6AScoWI0fu4VwC0qJGJhZJ75boD6hbMJaLHRWDN1n13guJ47DKauhbhQqeQZf
         ztTBO5Lwab5ez9H32eQxEi7f7Kt+FW1ZHZrasj5Bkhr34XRL41Fas6gSYsZ6AoTFtYxP
         QbIipFRDDob1mFei01eOfyUylzgLu6TokApqO0vLoB81PzmGGas1PQBV05EU+Pgdb7bI
         ZZtFCoz69LjJPodO33U7kY8uZSSCgf1uLzS3VjIO/7UV8kkzEGQDodD0J7b5KvWQr3wa
         NU8uaqSyxzGhcmv0ITMYK+D6OoCHRK5T8CXs1Tw6ELaWOuXNE4lkzg6DXeDNx2lACl+N
         hJXg==
X-Gm-Message-State: ACgBeo1Xi0cIWd6MPVDY4MJKxGK/UeuS9K0Bn0I+WY0VgMvhCFp1pwrJ
        1u/79zN0JVAnBd+8KhlpKjw=
X-Google-Smtp-Source: AA6agR4NGNy6sd7lOJB3v5oEPNucGUhI/04b/J+ZPx/wlg+HXvSCmcQ+oXJtibdOiQrIWWio12nKug==
X-Received: by 2002:a17:902:ebcb:b0:168:e3ba:4b5a with SMTP id p11-20020a170902ebcb00b00168e3ba4b5amr22386149plg.11.1659461240592;
        Tue, 02 Aug 2022 10:27:20 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:5297:9162:3271:e5df? ([2620:15c:211:201:5297:9162:3271:e5df])
        by smtp.gmail.com with ESMTPSA id w127-20020a623085000000b0052df34124b4sm1395724pfw.84.2022.08.02.10.27.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 10:27:19 -0700 (PDT)
Message-ID: <eb031a22-5275-4fea-71ff-d0fa7f47ccfb@acm.org>
Date:   Tue, 2 Aug 2022 10:27:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] scsi: ufs: enable link lost interrupt
Content-Language: en-US
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        adrian.hunter@intel.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
References: <CGME20220802014552epcas2p236519c03464ab32d9a877887710b1c10@epcas2p2.samsung.com>
 <1659404551-160958-1-git-send-email-kwmad.kim@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1659404551-160958-1-git-send-email-kwmad.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/22 18:42, Kiwoong Kim wrote:
> Link lost is treated as fatal error with the patch
> c99b9b2, but its event isn't registered as interrupt source,
> so I enable it.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
