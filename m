Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC037C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 10:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbiKRKih (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 05:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiKRKif (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 05:38:35 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845D59FFF
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 02:38:34 -0800 (PST)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id B6DE66601639;
        Fri, 18 Nov 2022 10:38:32 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1668767913;
        bh=Q9cDNMUrZzaaoL8GfB/cLKhDVomk3bjfsVkS+dBopu8=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=edY2m/6dcmzj22RlipFIaeO9mO84SReGq0zRskP7/cd0WHWU+EDIT4mTNPrQkWrlL
         d6menzinaCQz0Xx6zhtwS0vlRWT24HKTXobwmIPISibVhSgD9uVpB71D8wfPvN30g7
         a4ekSd3NWzAKKHVO5Wba20LmwuNhTCPlb4RFjE6I7SycNH9omosuVuH+xXCAfoBPr4
         3tat8HR8sOXm7X9a42d8lUSyU8hHXP0h5LY+GYcC/3LNZQJrcfkwrBiGMmFY4mN7jR
         9SqWUMTGG3LZiYUOBV2/amgltL97ggBbQCZ02DiH2oQil4nSsft72Tx7zvVvzDA2PT
         u9FuN/6x1oPvA==
Message-ID: <21582859-513e-953e-37f5-49b6cc0941a6@collabora.com>
Date:   Fri, 18 Nov 2022 11:38:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: Remove unneeded code
Content-Language: en-US
To:     Chanwoo Lee <cw9316.lee@samsung.com>, stanley.chu@mediatek.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        matthias.bgg@gmail.com, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org
References: <CGME20221118044223epcas1p12eab9a6fb08ec382625b3fb43f401e07@epcas1p1.samsung.com>
 <20221118044136.921-1-cw9316.lee@samsung.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20221118044136.921-1-cw9316.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il 18/11/22 05:41, Chanwoo Lee ha scritto:
> From: ChanWoo Lee <cw9316.lee@samsung.com>
> 
> Remove unnecessary if/goto code.
> 
> Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


