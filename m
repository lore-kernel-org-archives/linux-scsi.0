Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50BECC19F2C
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 17:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbiHAR67 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 13:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbiHAR6j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 13:58:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F8F3D5A7
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 10:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MDcFbzbPcPFFlFfC3fciKwLRu6LTJc6kvT/1ZcsrAEw=; b=T22qjUgenwCk3fkE5OjlFOL8jO
        2K1dvXxe9Po3PdPvgIkjsJ42d8bceebn+3wXcIU1Pdr5eDcs5Xj/Ns+CD2BhhtGwW6hdLKiSbw3Uz
        Xaq2r3UX4h39DLm/680EV8kHhHl6uQ3qB1AxjPkKotpAk0h7aAr4u8uRo8WIjjxWxzLpKyUZBcCKW
        CNSDKoYUCMvYXs5z7ovXtQIM+7Kk9Onj3GsuGSzVh3r73B+36PO7OXEy+xRUazuW1dfUT7h/okUVs
        27rzEWg18n4yyUKl39V6rS1+51aa/9+gAkzNry3gKAuvv55c50hEDhSZwFUIZ5FXVafweUvvLZ67+
        DXzUYOlQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oIZgI-008SPb-Pg; Mon, 01 Aug 2022 17:58:18 +0000
Date:   Mon, 1 Aug 2022 10:58:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 3/4] mpt3sas: Increase cmd_per_lun to 128
Message-ID: <YugUOiB6k8rcH87N@infradead.org>
References: <20220801124144.11458-1-sreekanth.reddy@broadcom.com>
 <20220801124144.11458-4-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801124144.11458-4-sreekanth.reddy@broadcom.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 01, 2022 at 06:11:43PM +0530, Sreekanth Reddy wrote:
> Increase cmd_per_lun to 128

Why?
