Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C0AC83F29
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 07:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236757AbjHaHox (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Aug 2023 03:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbjHaHow (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2023 03:44:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8671A4
        for <linux-scsi@vger.kernel.org>; Thu, 31 Aug 2023 00:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+SWd0AhVEOuLrqAg4Cs23P2JkG1SvXZDBsucru+4lwQ=; b=lhsyf6Jvn5AVof/YRuX7LtWyy3
        nH1g701gTe+ABQen510/XBpNhHfdF3EK9VOnE+lSi4aFt9/SaXydmv34+ydKGc2fYF1ygjFo01ble
        6ah7LnJHuc5y3Q7fmQ3HrH4EN16YS6J76ikD5EBctclgvuCFmczaddhQM1hNIZr8sTAgM3j8K62dL
        IhD4RWm7K2S10u+f1AXTXT9ON0au+oUmmBrEujtR2I6IEdg/2JJXs8dHu1Kwt2+ACFSOy9BPClPey
        gOQXwf0nvRxcd6vzVyzfwf9QJciSZ7w7KNHgzpw0LA4aub0RJ58NVeTmd6IeCw1XmEbBBTMrcwsod
        S5W6krnA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qbcMC-00Epfp-2K;
        Thu, 31 Aug 2023 07:44:48 +0000
Date:   Thu, 31 Aug 2023 00:44:48 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, agurumurthy@marvell.com,
        sdeodhar@marvell.com
Subject: Re: [PATCH v3 1/9] qla2xxx: Add Unsolicited LS Request and Response
 Support for NVMe
Message-ID: <ZPBE8AS+mazj+pBQ@infradead.org>
References: <20230821130045.34850-1-njavali@marvell.com>
 <20230821130045.34850-2-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230821130045.34850-2-njavali@marvell.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Marting, I saw this made it to linux-next now, please revert it.
qla2xxx hsa absolutely no business changing nvme-fc-driver.h without
ACKs from the NVMe maintainers.

