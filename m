Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CB7C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 09:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbiCBJtC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 04:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240632AbiCBJtB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 04:49:01 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D052E0B0
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 01:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=eiJfy1DPV1m9nM/wwunhaVqAtl
        3K5fMMH7Nf62H/Tb8zfoIHjVO8iaAASWLr2LbtDmLYIVuuG6kFIMCufyZmrjXJGeHZtYDj15mEF+o
        JWFHTnC2RPwq3gt5yA3Xaz6ZYfBXOlG0ZWopE9qy1nRerLvLxuY9rHqXT5o8b2QbJFqAsnPXR6stq
        5SQTHj1jcLtFJ+G9nx4uHlJHZ6RX/c4BHc/J1KyZ4urkx84rlFch78Ih+a6gql6mP6eY15GhXoNmq
        Wi1Ce0w0qTKFses6xZ8AceGYYZ7PgFWOSbDvttsPMqVgUWxfYKMi0svUNNzekAjiM3IO9bHIkBpyi
        iuoUrcXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPLaj-0027KD-Q4; Wed, 02 Mar 2022 09:48:17 +0000
Date:   Wed, 2 Mar 2022 01:48:17 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        "Maciej W . Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH 02/14] scsi: core: Query VPD size before getting full page
Message-ID: <Yh89YXOtETWxtn4V@infradead.org>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-3-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302053559.32147-3-martin.petersen@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
