Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E67C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 10:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241266AbiKRKjh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 05:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240866AbiKRKjd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 05:39:33 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428543E0B3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 02:39:33 -0800 (PST)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id BA4BC6601639;
        Fri, 18 Nov 2022 10:39:31 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1668767972;
        bh=oFMDujIPAAMn77bKnuEJQwag89/0lNbWafcLhGJMaPA=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=EEaC1m8BCzNf+WdXitUzWOZsPzcnRQZgLQU/YwjNXOzyq81lL1Y5lVwAtsVFddlSp
         CwlhWiCGOFy6iLxLTtji5A/PUf/4lO5aChkkQHwEe6REqyb8P61gpDfhL2sBsTLFTG
         mq01vaqsyS+PWjL9wKHlkjAzfj+AH3rekouO31/8w90+apC/Tk9TWRHV9j3W+nzlnP
         6rIP4jDx9iyRyh2+O3/q9J9OgPTv6wMkbA/TONS+ub9h62dL1ZL2JAw9G8w/50vgJd
         khlVbfdDhXaNDtOpx3euAaLEavf7pOYSAJmWVJkZA8oRqV7a6R7dqC4DbN+wEvQWni
         JeU0X/ICqUkhA==
Message-ID: <1d695cb4-2e29-b957-00cc-c0c39a47ff30@collabora.com>
Date:   Fri, 18 Nov 2022 11:39:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: Modify the return value
Content-Language: en-US
To:     Chanwoo Lee <cw9316.lee@samsung.com>, stanley.chu@mediatek.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        matthias.bgg@gmail.com, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org
References: <CGME20221118045326epcas1p408c9e16a58201043c9eb3c99110fab0c@epcas1p4.samsung.com>
 <20221118045242.2770-1-cw9316.lee@samsung.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20221118045242.2770-1-cw9316.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il 18/11/22 05:52, Chanwoo Lee ha scritto:
> From: ChanWoo Lee <cw9316.lee@samsung.com>
> 
> Change the same as the other code to return bool type.
>    91: 	return !!(host->caps & UFS_MTK_CAP_BOOST_CRYPT_ENGINE);
>    98: 	return !!(host->caps & UFS_MTK_CAP_VA09_PWR_CTRL);
>    105:	return !!(host->caps & UFS_MTK_CAP_BROKEN_VCC);
> 
> Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>



