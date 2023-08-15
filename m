Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C88DBC41513
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Aug 2023 02:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbjHOCTB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 22:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbjHOCTB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 22:19:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9C8A2;
        Mon, 14 Aug 2023 19:19:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D93E61E31;
        Tue, 15 Aug 2023 02:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE95EC433C8;
        Tue, 15 Aug 2023 02:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692065939;
        bh=WlbM/heytKtCeqZZp8rGyTYqC/JyepjBu46WF/ixl1E=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Gzk1/BLqzLvrLF8bTNxmpu6nd3or812jH4ByTp0KfVgkmEY6Jmznc4ktLBlyYo91t
         LUsbV55OoIGkMHwQL2Urdb68rCgd68q1rNrWT7blYbMWNuSqacDQ1SzUvQSn6ciVry
         o6X3+PGX9T3ypHZORax+KWzdmFTjPyTSMCH7iXo9JAWVwOtUnyuVhSOImnoN44jxOQ
         lVzTtBIFtg0x5k5VOGoVyTKH/yILQdA+XT87PmqrdSRytSP4X4g/0+PhEqL/0uxSiU
         Zp+0MqCB0qevEpZSes7Q9+zUd+s+owMbWI03ujxkyCKf8sLK1+mGZ8w92dznO45EqN
         kQpao+bF97J7A==
Message-ID: <1227c807-c452-09a9-5a10-4471f2e77053@kernel.org>
Date:   Tue, 15 Aug 2023 11:18:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] scsi:libsas: Simplify sas_queue_reset and remove unused
 code
Content-Language: en-US
To:     Wenchao Hao <haowenchao2@huawei.com>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     louhongxiang@huawei.com
References: <20230729102451.2452826-1-haowenchao2@huawei.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230729102451.2452826-1-haowenchao2@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/29/23 19:24, Wenchao Hao wrote:
> sas_queue_reset is always called with param "wait" set to 0, so
> remove it from this function's param list. And remove unused
> function sas_wait_eh.
> 
> Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>

Looks OK.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

