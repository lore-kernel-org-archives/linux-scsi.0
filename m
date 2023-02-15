Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9077EC636CC
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Feb 2023 17:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjBORxK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Feb 2023 12:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBORxJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2023 12:53:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6141BAC6;
        Wed, 15 Feb 2023 09:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=S+OnE5Otl4cKLCCRZAM92RTBgDsnX7rILCqnw0jQsUQ=; b=NnS+GjCmkIaYrFbh2ErZFUSENw
        Lr+o5GAFEphnFRxibaerLyuH0d4qIn3fDl5bnQIMtYShqaAizjQTA2ovHFJ7sozbSvH2BwOLPv13C
        L06VrKS6RTnfYnU0mTNUZYXGEzHDAhU1TZTxTHQ9BC21NZ4XaoMvo0fARMVC7O7Un9/MqZidBJ750
        UJANkhTcKhAV1Jd1pJAESL+rjw8dPP79euJjcpyb3ZlVATd0ETfNnPG46ZNeL09EXznITPs3Y2GIv
        xBxl/oxvgAOllvLffbtiLciZqDeJ6ImbR9oxc9eZqSSe9lSgdsTgKIGDnUwY1kez/P0b5L811wyY4
        Q3QpEFzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pSLxd-006lZh-P7; Wed, 15 Feb 2023 17:52:53 +0000
Date:   Wed, 15 Feb 2023 09:52:53 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Po-Wen Kao <powen.kao@mediatek.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        wsd_upstream@mediatek.com, peter.wang@mediatek.com,
        stanley.chu@mediatek.com, alice.chao@mediatek.com,
        chun-hung.wu@mediatek.com, cc.chou@mediatek.com,
        chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
        mason.zhang@mediatek.com, quic_asutoshd@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 2/2] scsi: ufs: core: Export symbol ufshcd_mcq_read_cqis()
Message-ID: <Y+0b9d+InjhKi7+H@infradead.org>
References: <20230215123750.15785-1-powen.kao@mediatek.com>
 <20230215123750.15785-2-powen.kao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215123750.15785-2-powen.kao@mediatek.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 15, 2023 at 08:37:46PM +0800, Po-Wen Kao wrote:
> Export symbol for driver module

Which one?  We don't export symbols without an actual user.
