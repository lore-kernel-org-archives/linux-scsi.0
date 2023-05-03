Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BC8C7EE22
	for <linux-scsi@archiver.kernel.org>; Wed,  3 May 2023 11:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjECLmY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 May 2023 07:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjECLmX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2023 07:42:23 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC64D46B8;
        Wed,  3 May 2023 04:42:22 -0700 (PDT)
Received: from [IPV6:2001:b07:2ed:14ed:c5f8:7372:f042:90a2] (unknown [IPv6:2001:b07:2ed:14ed:c5f8:7372:f042:90a2])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 003FA6603137;
        Wed,  3 May 2023 12:42:20 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1683114141;
        bh=TJaStcw6M4B58qZF10snuAZy5WmEbCUGpaBSgXcB3bU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NLpO7YpowMuvPI0VQ59s/HG7tJd0sVv1gtW3PjtHGP1OQw84duZZF5C52ptFyI9P0
         DVOh5Ru6igE33sga3bOquYgvVmY5JhLe+Bmi0llXaAywV1hIG7hhpbWf8tFApXB0aL
         EoSorC+WbAN7BY8hLMbf8NwYeawccQcNMemOeVpHXesOatTY5rjO4FH8W/nE+ogK8E
         yyLJsKPT147MusXx6ytLbh/0MVqRLxN4JsHTaYUE5OsrECAHnHw7M6ydLiU/NwKb8s
         9imBuh9oBbirxL1xVEwpzsRjoUwNmvXzXkLjUXfht6oIFeYUOHsfdofKsl9ml2haRC
         u34rjeUXFbOlQ==
Message-ID: <417dfaa8-86a3-6cd7-d377-3cd8a7eebaac@collabora.com>
Date:   Wed, 3 May 2023 13:42:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: delete some dead code
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@linaro.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andy Teng <andy.teng@mediatek.com>, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
References: <68fce64f-4970-45f1-807e-6c0eecdfcdc2@kili.mountain>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <68fce64f-4970-45f1-807e-6c0eecdfcdc2@kili.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il 03/05/23 12:40, Dan Carpenter ha scritto:
> There is already a test for "if (val == state)" earlier so it's not
> possible here.  Delete the dead code.
> 
> Fixes: 9006e3986f66 ("scsi: ufs-mediatek: Do not gate clocks if auto-hibern8 is not entered yet")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

