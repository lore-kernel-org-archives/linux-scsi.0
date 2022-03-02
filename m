Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FEC2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 09:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240778AbiCBJ6Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 04:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240829AbiCBJ6V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 04:58:21 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4B113E3C
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 01:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=gs1W4AAKceLqjIpeXbY1FkDOFl
        B56LH+6R71TWgyJjD3+Nd0YeDE3MILcwuSv3dKBjCGxUM21O/sHN+YMf/T23dMn0mw+nQJX0QAJ+T
        usHEf6fn8rIsDEH9Z32q7VtsMDhkk6Hhl1+vFimAsThzquMMxyE1czgjnijCnLl9bqdbAWkNj55m0
        A9JQvnoQfrrrGroZpFs1IOkgr6sZbWvpYxJGEuISfhLB5xgADehAEXV3FTtnVcMXBZLQpWeP+5J/4
        K9MmMtEbnAzFSWtKbi2YPkVIiiiARYduE3eWUTNVaJojvRTRc70bD4rr2coDjNohbekYw/m51Y43W
        aDXOhpyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPLjc-002B1B-Tk; Wed, 02 Mar 2022 09:57:28 +0000
Date:   Wed, 2 Mar 2022 01:57:28 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 13/14] scsi: sd: Reorganize DIF/DIX code to avoid calling
 revalidate twice
Message-ID: <Yh8/iI6qXODwuf/3@infradead.org>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-14-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302053559.32147-14-martin.petersen@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
