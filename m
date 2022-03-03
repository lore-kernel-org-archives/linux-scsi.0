Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A25C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 00:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiCCAlW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiCCAlV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 19:41:21 -0500
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642594DF7F
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 16:40:37 -0800 (PST)
Received: by mail-pf1-f180.google.com with SMTP id y11so3389436pfa.6
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 16:40:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q/PNdPe25gVpGQHBmI6noAqGXKjDOsGX9xO97fFZRVA=;
        b=Yg8LxTmrChXnixuzL0XqUXZ0IDqZbBTwIhaMU5HjWqGAfUi8z1b8Sf2D+FYF14myYL
         03W2ZDkAAo20KSLwbOr7/4M0Zy/LfIHGRpfaD72EAFcK3eUd9JbwaH2TcRUb28PymuPr
         arLVgTyHrvLNPi+Xaaa4dHAfN8D0RizBaY1p8B1tv/1BPfEwtt+6lhzxB5pU1yZKghhJ
         sfnp8LekgxyKQ9ReR3brujFc9rPZdUC1kFoLji/HmTvbAciNKkimKixV8rUpNVOpXEqy
         6xM4MzV+teZVY4aApO3pdaTe9eCW3OboZdeZ6yQs7kRgkZIjSDGK1zqVbbLC+0DJTLmj
         wotw==
X-Gm-Message-State: AOAM530hNAb6y4UTrwRAiIY4Bluuq3v32vYEAWu0qbgFpJCZMjRi0hsA
        925hrtQplYsRPsdnl/LvRQaBhkKs0Fw=
X-Google-Smtp-Source: ABdhPJyIouNuVvqA4N5U3egeGPC7LY56O6Ez4UDAx8ewmn+i2lQIYamCkZX0eyelKkul0yGqT0gT2Q==
X-Received: by 2002:a05:6a00:244c:b0:4f6:67b8:a6b4 with SMTP id d12-20020a056a00244c00b004f667b8a6b4mr1734658pfj.51.1646268036656;
        Wed, 02 Mar 2022 16:40:36 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id h2-20020a056a00218200b004f66d50f054sm306029pfi.158.2022.03.02.16.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 16:40:36 -0800 (PST)
Message-ID: <0c4f821a-1d48-bf20-5dc2-bfb7f435b207@acm.org>
Date:   Wed, 2 Mar 2022 16:40:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 06/14] scsi: sd: Use cached ATA Information VPD page
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-7-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220302053559.32147-7-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 21:35, Martin K. Petersen wrote:
> Since the ATA Information VPD is now cached at device discovery time it is
> no longer necessary to request this page when we configure WRITE SAME.
> Instead use the cached information to determine if this disk sits behind a
> SCSI-ATA translation layer.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
