Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32CAC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiDLXU7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiDLXUs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:20:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B709025C
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:07:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F053FB8204F
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 21:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F493C385A1;
        Tue, 12 Apr 2022 21:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649799006;
        bh=6GcLynZRWnw26OaQC8xbREY2TgH24tA243xH1doTwOI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WMZwkCE56EO5SFCivbcGOYwb8zu3rwHZrCy+vLCOvhuBI28lSLqmwu+c2Ynxf+lAL
         pdrk6OJJwsiyGH/rC0JAASz5szcS7hYydxQgPE6iQrKiA5CxL1AuwFWuONMldYoCGC
         C1s2Yqh+wdVPprRVgD60H9hUkU9zrlhXDv/ysDCYgVpUfIMCmk+AXC1ihHDGAHlB+H
         SzXRTOVYiVd3Sey501bf3ZbTA7oRP4sQi9HZI873Ys9ht0m0lPGc63Zt2JcpIKq0pt
         OAqgPnRyOmlzWVG6gvvVqtwDek4zn2gBiV4tGAJysXC0Np4H71vsYlpyGl7QTPpC5k
         J9Kp/7LyyszHA==
Date:   Tue, 12 Apr 2022 14:30:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH v2 23/29] scsi: ufs: Remove unnecessary ufshcd-crypto.h
 include directives
Message-ID: <YlXvXE61PPcFREZ8@sol.localdomain>
References: <20220412181853.3715080-1-bvanassche@acm.org>
 <20220412181853.3715080-24-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412181853.3715080-24-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 12, 2022 at 11:18:47AM -0700, Bart Van Assche wrote:
> ufshcd-crypto.h declares functions that must only be called by the UFS
> core. Hence remove the #include "ufshcd-crypto.h" directive from UFS
> drivers.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 1 -
>  drivers/scsi/ufs/ufs-qcom-ice.c | 1 -
>  drivers/scsi/ufs/ufs-qcom.h     | 1 +
>  3 files changed, 1 insertion(+), 2 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
