Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0611FC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Sep 2021 01:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB717610EA
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Sep 2021 01:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhIZBQp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Sep 2021 21:16:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230191AbhIZBQo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Sep 2021 21:16:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632618908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yPScCXbwrAnP+0zgOQn+0QEIePgNYmpv6jzS1EITj1g=;
        b=MDFUaH/IwLPMEQNbLQFCWfJ79OO0sz5HHgyNVNKJAm8GNPRM9KaGg1ctQ0EE2zJFx9utKJ
        LG/69dwR5GI0TSsIiaX3z5wIZ9LQLVfexCSzYzPNuzpPl+cSJzp+7wlc8yVZmt3vSwVc40
        rXftA9pId86J2s4b1NcafzeAforH4+g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-QeZEWMYzNeiaDL4jf0FJWA-1; Sat, 25 Sep 2021 21:15:07 -0400
X-MC-Unique: QeZEWMYzNeiaDL4jf0FJWA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F0A91808305;
        Sun, 26 Sep 2021 01:15:05 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DFE710016FE;
        Sun, 26 Sep 2021 01:14:57 +0000 (UTC)
Date:   Sun, 26 Sep 2021 09:15:12 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        hare@suse.de
Subject: Re: [PATCH v4 06/13] blk-mq-sched: Rename
 blk_mq_sched_free_{requests -> rqs}()
Message-ID: <YU/JoASUZbF+bqB5@T590>
References: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
 <1632472110-244938-7-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1632472110-244938-7-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 24, 2021 at 04:28:23PM +0800, John Garry wrote:
> To be more concise and consistent in naming, rename
> blk_mq_sched_free_requests() -> blk_mq_sched_free_rqs().
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

