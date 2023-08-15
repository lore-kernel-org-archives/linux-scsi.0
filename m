Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCBDCC001B0
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Aug 2023 02:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbjHOCOn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 22:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbjHOCOX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 22:14:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB19BE;
        Mon, 14 Aug 2023 19:14:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FB49655ED;
        Tue, 15 Aug 2023 02:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F35C433C8;
        Tue, 15 Aug 2023 02:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692065661;
        bh=wZZWakoCmL8C3Trm3epJ6X7aLlQiZ7J0bSsO2dW93DU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=WdOFKWFdyz2QhDwtfw64yNKrXMjeg5uxuwhFEvavcbs36k4JR3G/4htv26sRTW+Xk
         V7QgzNTiw2xwA7PEHpnz183aew7lmWSW7BafLk7hr5V5fGLrobBnVLX8CcLyPfuQPQ
         79pi2Ej3Cx7RpE8idfgk9b98jJz50Dxa1HEafagy1ZixdxVt78mtIp4rz6W0bQkZDr
         fy+/fZzvLKKdwKE9Tu/XjoenbEDpHvVWVrGWNMFSyqIRA0QXfKiog04D/c4t4gwZZW
         7eWQK5YFkIYRcAGVdU2fvQ2AMpfcAUy0icvVRCwoUrYeiNLkmaLeq+vMxeFmZGimp5
         rVGb+4xHexdYQ==
Message-ID: <e26abff8-ec52-2663-057b-fbefc3b818dd@kernel.org>
Date:   Tue, 15 Aug 2023 11:14:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 10/10] scsi: libsas: Delete sas_ata_task.retry_count
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, chenxiang66@hisilicon.com,
        artur.paszkiewicz@intel.com, yanaijie@huawei.com,
        jinpu.wang@cloud.ionos.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230814141022.36875-1-john.g.garry@oracle.com>
 <20230814141022.36875-11-john.g.garry@oracle.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230814141022.36875-11-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/23 23:10, John Garry wrote:
> Since libsas was introduced in commit 2908d778ab3e ("[SCSI] aic94xx: new
> driver"), sas_ata_task.retry_count is never set, so delete it and the
> reference in asd_build_ata_ascb().
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

