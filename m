Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12790C00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 17:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiHAR61 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 13:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbiHAR54 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 13:57:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04576DF36
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 10:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4AGBIvqYGEc7iz46/rHoisPzKl94Z4nXzpK7XzD4ejo=; b=RJkW3lvqjh9QC+IS/abgFXsl9I
        AqyT9Vo+I/4WvSk5tcN5Jtp6bXGxlym09S2Tz0Bf6DiAFOMeJRMgaSvduU4g7qUMtw0Uq6FIrWjiL
        twKwNxEloKYo1NZjwDC83YtAK0epZMcooI/n0jsLl7EKTvAvQa/0fHXQxmRFoEMp+HtyxPRKv5ZJE
        8vWjEus96crZucdSvCvm0ER2o4LzQPlfp1bVqrxG4k46oUkhVVvG6jcegYTfzCxmS4Zks0F2geqAC
        iGKKXexy/zb6nccDiIWvusjGg8M6rZae+wuVgZcdpeui5MImd0fknxEV7uQTz25vOsgGy8qOrg7jB
        0vs1ydlw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oIZf4-008QzX-Us; Mon, 01 Aug 2022 17:57:02 +0000
Date:   Mon, 1 Aug 2022 10:57:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     peter.wang@mediatek.com
Cc:     stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
Subject: Re: [PATCH v1 0/2] ufs: allow vendor disable wb toggle in clock
 scaling
Message-ID: <YugT7jfkMGGvH7hO@infradead.org>
References: <20220728071637.22364-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728071637.22364-1-peter.wang@mediatek.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Please fix up your wording.  A vendor can't do anything at all in Linux.
A driver might be able to disable things for a specific device, though.
