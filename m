Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664A8C6FA8F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Aug 2023 20:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240148AbjH3UB2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 16:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240196AbjH3UBD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 16:01:03 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E687173C5
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 12:37:29 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-271c700efb2so75392a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 12:37:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693424117; x=1694028917;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FRIggP1YvWWV3rj+5WU1Cj2nMoZrQOSbDSPE/2jMC40=;
        b=DMVhBhzmBmacCClY3W00x6LhrByuySjDpPBF/b3tGmlLvujQwqg3flypOE6R/flFzJ
         /rPoxwIYJwaQJK1brFAzw9vbAGkJbBeTSC+0eLokQXFaGuNd3d41rm3yeqp8miX17JdV
         ODxJWcozTUfSJoQHgtP/iH1kiyjMq6qtAOQz2ksKHp52jkNzzbQvq85GmM2W7BEdL/m5
         lKy7wFhTJ7TtHVoQ6O7uXllpuB7CwyjcfQCfxyjf80WCfP1wX38l1QHvVU5L3zBLwAPy
         t+OP6RSmAjeIX7EO+BH7pA/0+AK4xxiTetRcefKhZ+O4YBABOGElOYYKOp+ZVwDzsQBD
         JXog==
X-Gm-Message-State: AOJu0YyauVe0XzdKqMretuHIvOxYee09oA57aJKRKgiYTQjzuziGkIAx
        dicro7js8Nw+Ob3gmhp3MsY=
X-Google-Smtp-Source: AGHT+IFQrRHqdxwX8FGNjPvqUjKyXjSnMn0Trjge4hVFu0U8vQRp3+U0I7ZSwpaRY7c/EBJygs2cDQ==
X-Received: by 2002:a17:90b:150:b0:26b:5205:525e with SMTP id em16-20020a17090b015000b0026b5205525emr2799578pjb.42.1693424117089;
        Wed, 30 Aug 2023 12:35:17 -0700 (PDT)
Received: from [172.20.4.71] ([208.98.210.70])
        by smtp.gmail.com with ESMTPSA id l5-20020a17090aec0500b00256799877ffsm1568485pjy.47.2023.08.30.12.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 12:35:16 -0700 (PDT)
Message-ID: <a07bbc1b-0afb-4fc3-9da7-2dc1f6a4010f@acm.org>
Date:   Wed, 30 Aug 2023 12:35:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: qla2xxx: Fix unused variable warning in
 qla2xxx_process_purls_pkt()
Content-Language: en-US
To:     Nathan Chancellor <nathan@kernel.org>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        patches@lists.linux.dev, Stephen Rothwell <sfr@canb.auug.org.au>,
        kernel test robot <lkp@intel.com>
References: <20230829-qla_nvme-fix-unused-fcport-v1-1-51c7560ecaee@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230829-qla_nvme-fix-unused-fcport-v1-1-51c7560ecaee@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
