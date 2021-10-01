Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BC4C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 06:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6886D61507
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 06:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351884AbhJAGSR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Oct 2021 02:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351989AbhJAGSQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Oct 2021 02:18:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B6D961A56;
        Fri,  1 Oct 2021 06:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633068992;
        bh=uRhCoCH0T2pPwyMMrtCZpwXpGhC5/Pvxf2swNMGuqvo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CYo15rKP/+eEA9jDu7WeXeiIRW5WRaUdNgnWj7oceXI3jaALMK+lth8vJ/mSNyfGo
         EGqbj98H++YaQ2dwPPsyNJqM9rnpHKfF9sYUekJ8YCLeQQuuMUV6RhyLOe4oghx65e
         w0AFDsfGWKeo/UrAUfBLJ2otGgTP5eed1KLXmWSgGRf/ZFIsme0CjNculOe4YtgPeK
         yMFWxV4jlmqq1E6lb5rEbYVO8dxliZwovX+vyqg8CpRyEc/gCFtk77XACPpDcrHufg
         2yxMzLRJpiJgEc+qX8iA+rXSuQ1PdTTx697QvkLnSTTp9qR77FzpYypr95PqdRPzsC
         kGOu6BSAPgUBA==
Date:   Fri, 1 Oct 2021 11:46:28 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 1/2] phy: samsung: unify naming and describe driver in
 KConfig
Message-ID: <YVanvDPnpCpYjPgL@matsya>
References: <20210924132658.109814-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924132658.109814-1-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24-09-21, 15:26, Krzysztof Kozlowski wrote:
> We use everywhere "Samsung" and "Exynos", not the uppercase versions.
> Describe better which driver applies to which SoC, to make configuring
> kernel for Samsung SoC easier.

Applied, thanks

-- 
~Vinod
