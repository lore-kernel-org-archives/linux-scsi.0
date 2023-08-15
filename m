Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A12CAC001E0
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Aug 2023 02:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbjHOCNF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 22:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234159AbjHOCM6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 22:12:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EEEE5F;
        Mon, 14 Aug 2023 19:12:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A26C963C19;
        Tue, 15 Aug 2023 02:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EE4C433C8;
        Tue, 15 Aug 2023 02:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692065577;
        bh=y7Ex6KPHusap56/DECFllbyo1kqK8+2ZBrMv2KFUAfo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QaKEcaw+fdmwEfy0T8si1Z9MW/iXcS2KPUO6rQ3xi4n4Acq7maV4SxKRMBGaTHbHF
         2VEqkbndAFCUWJVx+ocOv3t9XRvNF7hmoxoTpkZEVbe54oo9XXEnLB8YIDo3yNt+R9
         tcSGtRpjc+c5B1zTWenBpJPryVD5cTLuLQnvC0ave1p4Pq1m8+IgUDcXT1MwkJFrse
         VLggrMlKGP21vrdWVQk1OKTrHfg1bHLRjnDWSUf0RWeO29R2dLqLOcU6ctWCJAOGOj
         pCb47ztHn4pnCaf/95YSyJyX/W9o0nZFbh8NViMGPslSDrmos4QzOuWgXBCDoQ+G0X
         s2VVFI1o49a5Q==
Message-ID: <e8fa6c02-5b3c-d6c6-0e0b-6a829636284e@kernel.org>
Date:   Tue, 15 Aug 2023 11:12:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 08/10] scsi: libsas: Delete sas_ata_task.set_affil_pol
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, chenxiang66@hisilicon.com,
        artur.paszkiewicz@intel.com, yanaijie@huawei.com,
        jinpu.wang@cloud.ionos.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230814141022.36875-1-john.g.garry@oracle.com>
 <20230814141022.36875-9-john.g.garry@oracle.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230814141022.36875-9-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/23 23:10, John Garry wrote:
> Since libsas was introduced in commit 2908d778ab3e ("[SCSI] aic94xx: new
> driver"), sas_ata_task.set_affil_pol is never set, so delete it and the
> reference in asd_build_ata_ascb().
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

