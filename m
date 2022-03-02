Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 682C7C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 09:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiCBJuz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 04:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240689AbiCBJuy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 04:50:54 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F373EBBE3A
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 01:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=oq3lVAjMWiun4K8uN8mhTWrg1w
        0GepbFb1YqEskAmB03yY4HI+yCYRSRWnt/pilonZiHHg3VwnpT2GYl2B0Mdw+wBdc9WQW4ncC7Jrh
        hEbl7RSckmDzoJXITssO18QZZj+OCg7lmEWmsEPfIEZg79Qzhnqq8fSkwH4WvMeONiKW8UhhESHOV
        c1nn0SzEz9s2MepbMeUPb4YK8KlQaIDyQ+G6liPnfdstZO9TiZ6pQxI3A18O5mIFj6muXQbvc3Odi
        F3irNoBMo/SR/N6n7HbnSGczgbnkKjZ2PJXcr2Gb7AiYY49QNgO85O4InTAOhthvQrRIuN0is3LFS
        fy6GnXNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPLcW-0028Dm-Io; Wed, 02 Mar 2022 09:50:08 +0000
Date:   Wed, 2 Mar 2022 01:50:08 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 05/14] scsi: core: Cache VPD pages b0, b1, b2
Message-ID: <Yh890KcrPAxqz40n@infradead.org>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-6-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302053559.32147-6-martin.petersen@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
