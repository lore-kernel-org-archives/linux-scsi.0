Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF498C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 09:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbiCBJwD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 04:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbiCBJwC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 04:52:02 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD6DE09C
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 01:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=3MZs55Co1kD8+0RYH6os+wMzBR
        EsRbWHLWD2id4B2LdLiqH/NDF3UlmH1npqfdwOw5W9mBrbQbqtqGrz9rjbM8JGoXDoBalO+1NL41w
        Ak6YtGKA4nqCy5jcqf37LEX+ep4iEQ3R6w7GlMX1T1rwQVCrRSwviA/xwdRHKGO2EkHBltmQoFZcp
        ncgvoS8kVQ1wJxDkCJvAEtWTSSwKQ+BK7sL2je+kDEH4A1Y0TX5nmLzkZzmtF2i0mRbWuWaM4RXTL
        QnHapRRmtKRyckX4pHjB/ICj2zdklFWYk+Rze0mk826Bi1H7fCFsExrBnG4EN3Bp9d015GH16dQXI
        JG/Qm7LA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPLdf-0028gu-MU; Wed, 02 Mar 2022 09:51:19 +0000
Date:   Wed, 2 Mar 2022 01:51:19 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 07/14] scsi: sd: Switch to using scsi_device VPD pages
Message-ID: <Yh8+F16r98DiR+Z8@infradead.org>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-8-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302053559.32147-8-martin.petersen@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
