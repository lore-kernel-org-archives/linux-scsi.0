Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CF9C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 09:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240726AbiCBJzN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 04:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240708AbiCBJzL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 04:55:11 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02EA112B
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 01:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=iWeNcdqcfiE/Vr5tQPLp2fysh8
        DNBsDTYRwJEFKZgFaaViHIm/3fHVTUOmjklbgGxINZFuFMYl6Q9UhfQmCwXYylNDcDWxZ1oaceMvm
        reMRFHU3+UEOBMoGZ7X6ahfS8TdjbnM0QSP2CMFaCtaIQkxinHHD4KJTxh+19Wrqmz/4q/x3pFEvW
        00HCVGQA59QJHHlfUGnE4fN2cfbtotB4KSAnXBtbovHufDfNZXELioh8apsW13mKHxEZxeZThfABY
        vY8BEJU8++l5UE7rHh1054sMfyOJLA7xpDtQcxEmaSQYAMVrM+XPM7zV61NSjIbssaE9dcEEPN5t9
        6Fbr1naw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPLgi-002A2D-AA; Wed, 02 Mar 2022 09:54:28 +0000
Date:   Wed, 2 Mar 2022 01:54:28 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 11/14] scsi: sd: Implement support for NDOB flag in WRITE
 SAME(16)
Message-ID: <Yh8+1L0w/w/Go2Bt@infradead.org>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-12-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302053559.32147-12-martin.petersen@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
