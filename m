Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19637C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Nov 2022 08:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiKUIEN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 03:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiKUIEN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 03:04:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F27020F5E;
        Mon, 21 Nov 2022 00:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WfwV1BD3xro5O1b5jqok86t3z7P7nMc04m7DnBEl6dk=; b=ScqZ0kaqfW7+kvCQmdcuN0SXq3
        pGGXqMac/OvGHWtcvZXGmkLDOi7DXyu4k9ExBEnA/6Ny6O1Yo9EK3S1gdotYfCJby9GoUdt/LRCPn
        iRmO43jNivjoZ4klIW7rJKJCSCAndPHkZQhTlqlWEAZcDCdyPyzgbhYgjwueZ28gvzfPt87RexIKJ
        wGzmWCOJNgNaDmxCmwzkAuRc0wFBR6chSDZreJowujkd1vXZWw7yF+g4ZzYvHac1JGuIrlie22oL7
        6h0L5w0K1MLhRTc4mF424AA3dySESGlI/qgpNjWkQbye+Je/uyodnYdu7gQHKkhxYfdt0R2hVKFYZ
        t8WEPtMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ox1ml-00Atrb-E3; Mon, 21 Nov 2022 08:04:11 +0000
Date:   Mon, 21 Nov 2022 00:04:11 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH][RFC] fix a race between bsg_open() and
 bsg_unregister_queue()
Message-ID: <Y3sw+wv+t2DeJKoh@infradead.org>
References: <Y3mbkZCESLLRMQNq@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3mbkZCESLLRMQNq@ZenIV>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

goner is a bit of a weird name, It'd just call it dead.  But otherwise
this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
