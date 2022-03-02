Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899CAC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 09:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240646AbiCBJt4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 04:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240597AbiCBJtx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 04:49:53 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8092B91F6
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 01:49:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=rl4BAGPZQJMjVAPAVAqklHKenk
        xhwB7m7Xx9irs09J0QHVIu12TGZhNMv+w1g3F26aFhS84SaFNT701moHDlM6yKEItki01PAoFnkZM
        te5YKm+fFlyAp/SevOZJb42u+HYKMhPgPHbZvF9Z9kYbMGOD8crpdv7xLG3U21gt+CCfoXbnOjt9N
        Ifb85LmEFgLWJzAhBUkQXib26zPbuelUrW0bHmfrHmp2ilZpJzw+jsqH01fpuExln/0GBmRfBGpJo
        ajByU3Qo2qZlU/OgyKkGnlOlBS62kO30iD3EgPzm0i0sLP9N5005gYLNoXjJUXb83y0hleGW++9Bb
        NOhyzACA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPLba-0027lQ-JT; Wed, 02 Mar 2022 09:49:10 +0000
Date:   Wed, 2 Mar 2022 01:49:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 03/14] scsi: core: Do not truncate INQUIRY data on modern
 devices
Message-ID: <Yh89lno/u/C6hZUT@infradead.org>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-4-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302053559.32147-4-martin.petersen@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
