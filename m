Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 246EBC2BA2B
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 08:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE09B20709
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 08:10:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m+nJBszF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgDLIJt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Apr 2020 04:09:49 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35304 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgDLIJt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Apr 2020 04:09:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JDEA4aSSIckcWLhH+0n2OyNXRY6oS0EWJxgESd0P7Gg=; b=m+nJBszFbsHkAkcCRyWRhrX4Zv
        5NtrbyIG4/Y5IncFEmp2qIQxkoEF5KFIIq48pM7xQgC1GMz4xjGbLUc718zSdW5Od0AlqYbbbUax9
        r88iM9tt2iOXp8h6GmY7QELnSiQFhrHv2j+RSSShbmeiJqSDp8qk0B6wK5X2elJHHhLBi9GCj8Snh
        2SfJH+iY9pIJGHcV73jjj1fj2wjZjpqO3MQEVyJnZ+UMaZNjLly9DqLf3iJhc6qSxzGdhP74sZiRg
        BWVggmTXTwsTbb01g/NvP5TG34P3zzYcg42vAhWEZUeooECbyY62rKILwUSjEs/AYYL3tKeBNCOMr
        sfWZU0Mg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jNXgZ-0001kE-Rp; Sun, 12 Apr 2020 08:09:47 +0000
Date:   Sun, 12 Apr 2020 01:09:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     robh@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
        krzk@kernel.org, kwmad.kim@samsung.com, avri.altman@wdc.com,
        cang@codeaurora.org, Seungwon Jeon <essuuj@gmail.com>,
        stanley.chu@mediatek.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 4/5] scsi: ufs-exynos: add UFS host support for Exynos
 SoCs
Message-ID: <20200412080947.GA6524@infradead.org>
References: <20200412073159.37747-1-alim.akhtar@samsung.com>
 <CGME20200412074218epcas5p3ef7973c8a47533a15a359b069da8003c@epcas5p3.samsung.com>
 <20200412073159.37747-5-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412073159.37747-5-alim.akhtar@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Apr 12, 2020 at 01:01:58PM +0530, Alim Akhtar wrote:
> This patch introduces Exynos UFS host controller driver,
> which mainly handles vendor-specific operations including
> link startup, power mode change and hibernation/unhibernation.

So this doesn't actually require the various removed or not added quirks
after all?
