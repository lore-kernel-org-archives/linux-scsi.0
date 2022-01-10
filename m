Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D77C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 08:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242452AbiAJIvs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 03:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242032AbiAJIt2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jan 2022 03:49:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4291C02983F;
        Mon, 10 Jan 2022 00:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=w+81UUeOQQcmOK+na7XtOiVOrY
        cN6CD+Vo3LUP1ck2M8KAxYoiX2jjSJJAYNWAfVsFv1TqJOKPPyGqeOdmGvxxyGo8/Wtic530rtjuH
        Corf1TtEJV/jIGIE1kn4i+octxbzJkoxOpC5isgeNvZ1gCSnjn8seKV6nEPEi16iSV22e/Iq7Wktj
        G1v4k60eM9ikRZVdIgINgGbD80+16ZcSHckC57CczwbjVpKZguKEXst7IMMtyeby6i0ic16cfrt9Q
        wcDPWA8mnKNDrvY/Du+Sn5j737IFCHK8MOHmFk7vq63rGfKVM7lWDnkw5XScSwL4OH2bB934tqMGZ
        XXZEXWug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n6qLl-00A1mD-GL; Mon, 10 Jan 2022 08:48:21 +0000
Date:   Mon, 10 Jan 2022 00:48:21 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     arnd@arndb.de, hch@infradead.org, akpm@linux-foundation.org,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 14/16] scsi: mptsas: Use dma_alloc_coherent()
Message-ID: <Ydvy1ekVQ9KRy0e7@infradead.org>
References: <cover.1641500561.git.christophe.jaillet@wanadoo.fr>
 <443b81ecb08b2fe6f789bb2fdff13a53c809e401.1641500561.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <443b81ecb08b2fe6f789bb2fdff13a53c809e401.1641500561.git.christophe.jaillet@wanadoo.fr>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
