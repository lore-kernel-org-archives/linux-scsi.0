Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270E6C6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 07:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbjAQH0M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 02:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbjAQH0H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 02:26:07 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A6C23DA2;
        Mon, 16 Jan 2023 23:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GPkiB951ErunHBBEcpx5C42l6s
        eeO1MTO8sWXodu2Syeg3DjAo4FH/9mTDNyXVoyFr5B/g2ijFGVaefIh3/oBCrntk/lHv2tSq4oa4V
        EeNvRNmE8yQW2ywUmWW/XJj/GoLTRA5SD4QY6+q3VcqusbbDoTIVM0o9OVwG24yj1CtZQbNEEYB9r
        EWyWeBDq2t8lVPiTvVdAKZ8XFhav1yd3Is+1rP9I5Ee90EmlXb7hwRL7fytBvdQJ5sDHnQY6SkVAZ
        6V5wIIG557CR/tcPng100ECBoYNfCDO+Hz5d7fQ3w1Ao5GP3bv3EA8YprohLdBF+lk8Sgo5WXZmEf
        4Hx6QWKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pHgM8-00D9iP-Ft; Tue, 17 Jan 2023 07:26:04 +0000
Date:   Mon, 16 Jan 2023 23:26:04 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Niklas Cassel <niklas.cassel@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH v2 08/18] block: introduce BLK_STS_DURATION_LIMIT
Message-ID: <Y8ZNjDJte4yDlYSW@infradead.org>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-9-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112140412.667308-9-niklas.cassel@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
