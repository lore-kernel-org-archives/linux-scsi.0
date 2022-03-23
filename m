Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07340C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Mar 2022 06:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241040AbiCWGiT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Mar 2022 02:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiCWGiS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2022 02:38:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AFA71A29;
        Tue, 22 Mar 2022 23:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dIcO2O5bBX9E+mrtJnriFMKGfN
        ZcdTz5mLp/7l7VJwolhENKm76cr/aEHm9/0WNDH51F1r+pumqzR9Ixs8AwZG//Goy0QF1f8NUk7If
        +wcq761TgoyQI/YSWvhM3hYd8kLogASD3Hhwulv+TlTs5LH8oDN9LpsJIZN6NnrVxoAT2tQvOx5U7
        Wi/+rxvAnXDERrkr5Nj2unwuj4iaTco1r3slbKbJQuqNsawLGg9V8VA2lOLKNRoPTXZKJWy98uAwj
        w9Vk4dKkjO72UosDJ6VqNSZjEe+meNiaSYH+H8uAKY9hspOMP93M2oJlcObmUlxeYEXp/qx2bs1tA
        uPU0bdQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nWubt-00Cr2s-BT; Wed, 23 Mar 2022 06:36:45 +0000
Date:   Tue, 22 Mar 2022 23:36:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Kevin Groeneveld <kgroeneveld@lenbrook.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sr: fix typo in CDROM(CLOSETRAY|EJECT) handling
Message-ID: <Yjq//TsTcrmkp8FX@infradead.org>
References: <20220323002242.21157-1-kgroeneveld@lenbrook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323002242.21157-1-kgroeneveld@lenbrook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
