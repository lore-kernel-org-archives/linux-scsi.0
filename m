Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3242FC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 09:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240714AbiCBJxc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 04:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240719AbiCBJxb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 04:53:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCB3193FE
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 01:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=zaStTvF6p1X49NLqgdGJ6R+xWw
        1jg5ZEKHlzbBw8vphAAbcK+3MwkwvNKpvXUXRtbma+z3a9pfv0H7qHLNfeOQ4OsjYQ+T3hxoM/8ie
        NgJ4FVJ+XDrjiGeP0yrX2tTOI7/rTWdyFp5lGHBfcSLRSrSfRJncxqbLrcDrcTMkgND0koYUunpr4
        EyIhW0/slBawMAOZD8yrg5pLa8iVh7+ujX8ZaXXAe0QCXhCa0axpeAs76HF2RBOkkjyLg9T/jWacc
        znXh4nB2WXaZGfFPMRYk9yYX602tUyogpruDsaMXDyR8gb3f2Z6rdGlNJhTT35Uey1HPXJBLG8VUV
        TiAGD/sQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPLf4-0029Le-Mt; Wed, 02 Mar 2022 09:52:46 +0000
Date:   Wed, 2 Mar 2022 01:52:46 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 09/14] scsi: sd: Fix discard errors during revalidate
Message-ID: <Yh8+bpXuc2mF4D3k@infradead.org>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-10-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302053559.32147-10-martin.petersen@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
