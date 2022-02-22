Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05162C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 08:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiBVICY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 03:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiBVICX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 03:02:23 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F61A2516;
        Tue, 22 Feb 2022 00:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=06XZ3dsgxF8h4tvghiPQxLaZ7/
        aqQx+tRVIaNrOMPwGganxLCi38SbzAh6s3vk6utiUcYSeVAM2YABi1DuDE4qUzSHm72kwpvz6qfze
        WeqoCzQwV1VnBxz+diJvXzIoy+aGqzOLyTKB5YgYYjHzGksN0p5ruipa0cOwKtu3kN7lO5w5eYbA4
        8HxztIuleebwMObS2AHeVkqJZHu2mjfOK5hFJYxzndZZBnmE8kEXn4njQP911WDf/wBZbS0Pl5PAp
        Cn0/nmfi399DwVyRcW1LDORB7pScxFlrQFTl1VIBaWK0+chXkiDxPBMb6Q3cwGDLSA/JkvdSBvJPw
        sZIQ9+8A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMQ7P-008R64-EG; Tue, 22 Feb 2022 08:01:55 +0000
Date:   Tue, 22 Feb 2022 00:01:55 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mac53c94: Stop using struct scsi_pointer
Message-ID: <YhSYc0ZZeM9Tox/N@infradead.org>
References: <3529a59873a7de8455a27af2528341afe5069adc.1645484982.git.fthain@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3529a59873a7de8455a27af2528341afe5069adc.1645484982.git.fthain@linux-m68k.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
