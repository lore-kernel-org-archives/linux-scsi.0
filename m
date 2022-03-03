Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1820AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 20:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbiCCUPV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 15:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236328AbiCCUOt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 15:14:49 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2272119F16
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 12:13:36 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id e6so5654940pgn.2
        for <linux-scsi@vger.kernel.org>; Thu, 03 Mar 2022 12:13:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S9f9JacSinmIDvOyv7a8Quu+oNWS7WLrjtnDNIl+0Qw=;
        b=rQetyU64yxN9ozLfezEr40ocbT8Oq+5sNPwfRCmCGThTZqngCAdWwUm/RLkfxPGSUp
         gNAbwBEMvH2F1D6ONq0dnbIgFxntmryC+8iVMdBA5SCT1phhmY7A1G2Rzatp7cVBjUKy
         tIimqWkEA66DN2DDnufakAGQJFzFb7W+vzD6uMRqU8AEA/UMNGnLbepi7fuMssUOuSFZ
         LPhzA/Z5vIHpRPibtP+Rj16tAkiqcyDJSriSNZsgCXhvgMhoNnh0R6seOxkrSzeHQcVJ
         25nHdgeZsurLsR+JjYjKtzFC8Wly31ngcINo3iOzeylUnmmIh8gqodSnhzFsYnjrdh/l
         /MKw==
X-Gm-Message-State: AOAM533xHt1gbBabu5kcdtf6Rnt/xPwS5x0Aa13Hfp3TJxhVOq8GSoSO
        CnQgGQ0qfdCi3H+7a8RE0hw=
X-Google-Smtp-Source: ABdhPJwPstnXspQADYSVjHEU/ri06xYXvVdsvH8xekw4Ai+kqduwEN2NHz3oSgcfHvJhmj6A488QhQ==
X-Received: by 2002:a62:7ad5:0:b0:4e1:5bda:823b with SMTP id v204-20020a627ad5000000b004e15bda823bmr39798168pfc.75.1646338416328;
        Thu, 03 Mar 2022 12:13:36 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e11-20020a63e00b000000b0037341d979b8sm2671423pgh.94.2022.03.03.12.13.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 12:13:35 -0800 (PST)
Message-ID: <ef53f60c-96bc-363e-b955-cce3df09b220@acm.org>
Date:   Thu, 3 Mar 2022 12:13:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 12/14] scsi: sd: sd_read_cpr() requires VPD pages
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-13-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220302053559.32147-13-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 21:35, Martin K. Petersen wrote:
> As such it should be called inside the scsi_device_supports_vpd()
> conditional.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
