Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4159C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 06:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiJQGFp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 02:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiJQGFj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 02:05:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151234F19D;
        Sun, 16 Oct 2022 23:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=I0h2NuGC5H/Yd3RCfT81o/F9rHsMkK7NhGarQVPkQSw=; b=PKa3SiFqVTSLsKC7Zw6QVCObBq
        j4xOkkCBAgNTfrK44eNofdfDny9WdSjDwZZ9hPt84kn6rE1tKZW/0SELVsndjzS5y+mdXnkN7uWBE
        ybnXUd4KK0aX8tkIpjMXwd2hNpHStzXuH/I0DkSVs5Wm0iBxa55ESq/V+t8shqXBucPcunN3uIQpu
        mXD0T9d5Rtm3YUxyoA8+tQpDc85IRbr4Hp2bgGiytqOzLE5u215dQthPhq81sffHy2Oh20JMAUPyK
        7JHTMQ9L4sDEvD/KwtKS3XDVSwAqqrCfY5BhXEHqFxAYwWAvb00ktUyT3aosbUcu5Fg5d3k5lc5LL
        nwgqjsaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1okJFo-007kW3-St; Mon, 17 Oct 2022 06:05:37 +0000
Date:   Sun, 16 Oct 2022 23:05:36 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com
Subject: Re: [v2,PATCH 2/3] target: core: make hw_max_sectors store the
 sectors amount in blocks
Message-ID: <Y0zwsC6UAtdEfeg9@infradead.org>
References: <20221014114549.32888-1-a.kovaleva@yadro.com>
 <20221014114549.32888-3-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014114549.32888-3-a.kovaleva@yadro.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 14, 2022 at 02:45:48PM +0300, Anastasia Kovaleva wrote:
> By default, hw_max_sectors stores its value in 512 blocks in iblock,
> despite the fact that the block size can be 4096 bytes. Change
> hw_max_sectors to store the number of sectors in hw_block_size blocks.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
