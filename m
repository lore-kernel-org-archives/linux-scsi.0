Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B6DC4332F
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 03:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbiCFDKr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Mar 2022 22:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiCFDKq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2022 22:10:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A969475C38
        for <linux-scsi@vger.kernel.org>; Sat,  5 Mar 2022 19:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646536194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hcjadm1gq4MyOx+Ueqgl9eZG545kRKAUppIJppj92Z0=;
        b=ZoVHUq6ONBfOJ6qKa57Eh7auWhvyAV75LH8uVGXG0wI4Nz3wpnWNEKtIt9CwEQGSJxgGBk
        G2vaUwrm/hwiIt+7Yl3VymaDy4fGL+IznH8rxlRjJdhv4cHRIJPJUeI9IDK6pMaVZRXtEJ
        xXX2kAfvE4cXa2wbBka9TPb/53PGsg0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-Img0qrmfOfqknZhoLRcsdQ-1; Sat, 05 Mar 2022 22:09:51 -0500
X-MC-Unique: Img0qrmfOfqknZhoLRcsdQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1F82180A088;
        Sun,  6 Mar 2022 03:09:49 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B2E944D703;
        Sun,  6 Mar 2022 03:09:40 +0000 (UTC)
Date:   Sun, 6 Mar 2022 11:09:34 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 03/14] scsi: don't use disk->private_data to find the
 scsi_driver
Message-ID: <YiQl7gjJg5VDV1R4@T590>
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304160331.399757-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 04, 2022 at 05:03:20PM +0100, Christoph Hellwig wrote:
> Requiring every ULP to have the scsi_drive as first member of the
> private data is rather fragile and not necessary anyway.  Just use
> the driver hanging off the SCSI device instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

