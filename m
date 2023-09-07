Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E97EC8740
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Sep 2023 16:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbjIGQBO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Sep 2023 12:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238011AbjIGP62 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Sep 2023 11:58:28 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651EF20900;
        Thu,  7 Sep 2023 08:45:34 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id B4A5B66072EB;
        Thu,  7 Sep 2023 10:03:20 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1694077401;
        bh=cxgHzHn8tiosscM7rs1t8c0B3y0bEz5hVnyonEDHwcQ=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=Jg1VsCm9fyb2bJm+Y5M/Ced1kTka548X7IOgeXjgnnWl67hvNS821o1bKeDkQu2WE
         brIIQdtFGeGVK3M5Dk2Pt0NhVtC6msKiIq1jyReoAQwjBIrv6LCzEbihfwYz9k1HAx
         lt7VIocWeYNT+7l6SezTDlpFKPLmRiY2hU34cR5LpuhG8Z5WQ9nKgNRxZjSKh00rQc
         nxbnx1vT52hGtcgAsMgSHRT1pLGcl3sFQNawVJZ0+eE6IzDdtXHg2y2rw1mdhjLKki
         s+87GyXOpqw8UQ/DD43vAn4RnWAlEmY0twKQPoTAOgdIoP4l+3emRC86Bq3kD3AN72
         p3l9H8ciY53xA==
Message-ID: <827ba3c8-198a-7d1d-4511-b7aa9710b27f@collabora.com>
Date:   Thu, 7 Sep 2023 11:03:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH] scsi: ufs: do not look for unsupported
 vdd-hba-max-microamp
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20230906113302.201888-1-krzysztof.kozlowski@linaro.org>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230906113302.201888-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il 06/09/23 13:33, Krzysztof Kozlowski ha scritto:
> Bindings do not allow vdd-hba-max-microamp property and the driver does
> not use it (does not control load of vdd-hba supply).  Skip looking for
> this property to avoid misleading dmesg messages:
> 
>    ufshcd-qcom 1d84000.ufs: ufshcd_populate_vreg: unable to find vdd-hba-max-microamp
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

For MediaTek:

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


