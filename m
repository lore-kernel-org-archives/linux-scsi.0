Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDAAAEB64D7
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jun 2023 07:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjFZH7H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jun 2023 03:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjFZH7G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2023 03:59:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9CEE5
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 00:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=B1IhU6QGvWI+tEqwfoAXDc9a/Z
        ahydJbhTSq4tgvjlBLWCYpvaiK5+N79zHRRmPo5kKofTTDviIz52sVTd8TGzVCvCFQtgH2KUn7pUY
        GyRRV0KQWQD6BG7sjE+Nv9TSku5M+qrKHfwOAkPzJyQXnWlyWLWOehqWKEQB0uhtS1Yq+UiLv10Az
        9A86KFC06JPghmDD/pqn5slpcmaT6DxG6JwWXrg6FvnlMtc7lHUFBx/sER6Tq8jdLGhZxXdjZRevV
        SB9nhUXaZF3Q2FPTkOhkur8NfppxQHJ4KTojoe4jdoF1bZsaJ5VbPQ2mpxoTU4sIR5K7PftB+kT2X
        Y5MuAscw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qDh7o-009bam-0E;
        Mon, 26 Jun 2023 07:59:04 +0000
Date:   Mon, 26 Jun 2023 00:59:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [PATCH v2] scsi: Simplify scsi_cdl_check_cmd()
Message-ID: <ZJlFSKMGuYhTLd16@infradead.org>
References: <20230623073057.816199-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230623073057.816199-1-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
