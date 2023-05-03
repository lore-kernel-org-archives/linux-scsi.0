Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823E8C77B78
	for <linux-scsi@archiver.kernel.org>; Wed,  3 May 2023 11:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjECL1z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 May 2023 07:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjECL1y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2023 07:27:54 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D460C44BE;
        Wed,  3 May 2023 04:27:52 -0700 (PDT)
Received: from [IPV6:2001:b07:2ed:14ed:c5f8:7372:f042:90a2] (unknown [IPv6:2001:b07:2ed:14ed:c5f8:7372:f042:90a2])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 9A3346602216;
        Wed,  3 May 2023 12:27:50 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1683113271;
        bh=WGP0OsbH2dPidYUkXRTb9kc57nZTa9POAYu8FBpWLdg=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=W7ShblDGwb47x0tMalPyWMDd2viKXWq6mr0p4SD3m63lrOaTFJAO8q1FNbL2sbyP6
         hAQnJvdg5Xnq8hFSERQ1WzU5pXueTNEha8LntyFEsBKhB5Hyu5wHc3kJ04Tcbd4FEE
         isMMs0mVgP1PiYib8jLqWXpZP6cYZYF6bhhXQzLUfHollgrNd/DeFBS9a3ujoRysId
         JVgQe2uqAnzQ/j40ckLSufZVCF+B9Ws8mcGW7OfOS8MiVBZ+7mGnRsqCVBLR0J2X0N
         t5G6YGZZ11XmJcxbN01iwZQLfXvgXZuavxhUUby614lsyb8rYEroJd5GM2uYwov02G
         qciHTQ1jzasyA==
Message-ID: <aceca9c5-6379-4a52-86ac-46c7bfda9876@collabora.com>
Date:   Wed, 3 May 2023 13:27:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v1] arm64: defconfig: Enable UFS support for MediaTek
 platforms
To:     Stanley Chu <stanley.chu@mediatek.com>, catalin.marinas@arm.com,
        will@kernel.org, matthias.bgg@gmail.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com, bvanassche@acm.org
References: <20230503104423.21702-1-stanley.chu@mediatek.com>
Content-Language: en-US
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230503104423.21702-1-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il 03/05/23 12:44, Stanley Chu ha scritto:
> Increase build and test coverage by enabling support for more
> hardware present on MediaTek SoCs and boards:
>    - MediaTek Universal Flash Storage Controller
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

