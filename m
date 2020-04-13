Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B25C2BA19
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 13:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D77C220767
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 13:39:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p6MEiDx6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbgDMNje (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 09:39:34 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52960 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730096AbgDMNjd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 09:39:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jkhWCCzkP+x6/wVr5gKMTK9HQ5cEsrvEwtuoxjuudYI=; b=p6MEiDx6FJyvY3WjQo+n3jZ1ki
        jQ7NznWXny5tzqSSU0UmTzL9tX6XyN1MvKjwpmOeJSADnRoDbyn6Z8gy8OYKn4Bd6avM2G/nn7Xtg
        1M7kESWQlCKyycmQWwZ85iKv1YvQmQxO2MVba/BTw/ssmLKrmovXmBh3PLFLH7Gmmtw1729lniNq4
        kqSt7/+5v1jnkFT3CbxIo0IIRI9DlbxchDzciLUt1IKdsGRxFkie3MZtD5IDFgvLX8QVCIp+qSKQV
        tvLdGW3mMP/RYFnaABNe2oilISOswyCEWWPQF8yD/35rRUse4rH3Q/hevivg/BXz66S4toJ1OuJJ3
        xEFjXEsw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jNzJ8-0007f9-NS; Mon, 13 Apr 2020 13:39:26 +0000
Date:   Mon, 13 Apr 2020 06:39:26 -0700
From:   'Christoph Hellwig' <hch@infradead.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     'Christoph Hellwig' <hch@infradead.org>, robh@kernel.org,
        devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org, krzk@kernel.org,
        kwmad.kim@samsung.com, avri.altman@wdc.com, cang@codeaurora.org,
        'Seungwon Jeon' <essuuj@gmail.com>, stanley.chu@mediatek.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 4/5] scsi: ufs-exynos: add UFS host support for Exynos
 SoCs
Message-ID: <20200413133926.GA29228@infradead.org>
References: <20200412073159.37747-1-alim.akhtar@samsung.com>
 <CGME20200412074218epcas5p3ef7973c8a47533a15a359b069da8003c@epcas5p3.samsung.com>
 <20200412073159.37747-5-alim.akhtar@samsung.com>
 <20200412080947.GA6524@infradead.org>
 <000001d610e6$e8b11450$ba133cf0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001d610e6$e8b11450$ba133cf0$@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Apr 12, 2020 at 09:54:53PM +0530, Alim Akhtar wrote:
> > So this doesn't actually require the various removed or not added quirks
> after
> > all?
> This driver is actual consumer of those quirks, so those are still needed.
> On Martin's 5.7/scsi-queue need to revert " 492001990f64 scsi: ufshcd:
> remove unused quirks"

No. You need to include one patch per quirk in your series to add them
back.  Please also follow all proper kernel style guidelines, as the
old code didn't always follow the proper style.
