Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE5EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 05:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D81A61168
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 05:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbhKJFoi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 00:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhKJFoi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 00:44:38 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EACC061764;
        Tue,  9 Nov 2021 21:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=DQbtuyzBSIDdc3WlW44JUTUm9o
        ZP9c9KNWqgL2sIKlKJuKtgf3bJDBkf2FEpRqjyT3fmxVOXHTLMbF1WQ4qnFeKkwpfkVp9bBWNiRYm
        hl117iADOvKW+2a3SRU1khJcjJOxjSmfiy245bzeAQV2cyruAV/RBT742m3QHAcl5X7COwE/jZIV5
        4iqCN0iC95TUZuvchJ7b0Wf/TDIXvlJAljuGeIAd/bKrpCjLlndvqe4ui6HQJMSU1Hbz0iUSZAhXa
        XNS2nceGcyd/RopsBu5dQhUlVLzxLaWF/0kVv4paVy3ULDhh960nlP8dPNgMxtixvOX+CzDMPURyQ
        QiOetQbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkgMm-004VOZ-Iu; Wed, 10 Nov 2021 05:41:48 +0000
Date:   Tue, 9 Nov 2021 21:41:48 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     brookxu <brookxu.cn@gmail.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: core: use eh_timeout to timeout start_unit
 command
Message-ID: <YYtbnAWn1WbX8SwS@infradead.org>
References: <1636507412-21678-1-git-send-email-brookxu.cn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1636507412-21678-1-git-send-email-brookxu.cn@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
