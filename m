Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06582C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 14:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D220D6120C
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 14:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241178AbhI1OfL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 10:35:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56409 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241080AbhI1OfI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 10:35:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632839608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9uo/D5smoekZBXjsk5/VejATsNYCyWIWjL6ZaEUjIsM=;
        b=EHU+3mdPBG9cDAM4wiPluegOMVnjkt8rcx4LtzWGsIrX7cXmcl8xoyDZV3hXbtwGkqt+D1
        lspCZrLOuh6ZlLUEy1eVdhiNxfmtHrAAXgABFuReF1r+i32qoGSEOGxYPoKx/wK1GjGBlv
        iO0OBDSwoWUIutHgl+whBcXU9b0iIQo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-7t-VHZ6KP3SyimeTwHt_UQ-1; Tue, 28 Sep 2021 10:33:04 -0400
X-MC-Unique: 7t-VHZ6KP3SyimeTwHt_UQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74DA28E4AA5;
        Tue, 28 Sep 2021 14:33:02 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9494518EF2;
        Tue, 28 Sep 2021 14:32:57 +0000 (UTC)
Date:   Tue, 28 Sep 2021 22:32:51 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: remove ->rq_disk
Message-ID: <YVMnk/8HIR/yhWYr@T590>
References: <20210928052211.112801-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928052211.112801-1-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Christoph,

On Tue, Sep 28, 2021 at 07:22:06AM +0200, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series removes the rq_disk field in struct request, which isn't
> needed now that we can get the disk from the request_queue.

Can we hold on this series until q->disk becomes really reliable[1][2]?

[1] https://lore.kernel.org/linux-block/20210922172222.2453343-1-hch@lst.de/T/#t
[2] https://lore.kernel.org/linux-block/YUQOBKa67R9pEunr@T590.Home/#r


Thanks,
Ming

