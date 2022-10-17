Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16665C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 06:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiJQGFT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 02:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJQGFS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 02:05:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA7227145;
        Sun, 16 Oct 2022 23:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Vmx51D3J5/IdZF804At64GjfRy
        DScX1/eGwnvKDFWrvycajW5gjNfhDmpSO0ZStKd3brjDEWhT9w1uzKeuPKj1l5BRk4NKQeu7jS9l8
        WAh9J030c60HmdZDpTRfzZVUmqoJ873jK6VrbHae3P3D+juL+deLOA+41I2Dl5pnZzWrGrTdBzocn
        NyxA9uY+Z4KpLSlNr2C6Ou8ZVIm3ulCJ9qI/7qRyA2vnPEwm4Wi1/2akRbx3IdoADgphjMz43FOiY
        K+RGgAn2D3ceY3OyhqQvxVyHTBMT8haRxpxfm/Amr/5LqUlIZI1C1cEr1va+c+bBqWxKiudTNd5eb
        xjjAhZZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1okJFR-007kAY-IA; Mon, 17 Oct 2022 06:05:13 +0000
Date:   Sun, 16 Oct 2022 23:05:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com
Subject: Re: [v2,PATCH 1/3] target: core: Send mtl in blocks
Message-ID: <Y0zwmRE2DckP63mk@infradead.org>
References: <20221014114549.32888-1-a.kovaleva@yadro.com>
 <20221014114549.32888-2-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014114549.32888-2-a.kovaleva@yadro.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
