Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D396C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Sep 2021 01:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72E1660F70
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Sep 2021 01:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhIZBnw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Sep 2021 21:43:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230207AbhIZBnv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Sep 2021 21:43:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632620535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=69hvOg/aNlqj7cPzOpD/oj5gA9aDfCWSctqqldMFHI4=;
        b=MTXLO6ZmgR0TrmOxZcRk9uVbUklRXXtE9Pho6aYLqdEwseSn51M9hozIavtol4N+it0VRN
        y4+gaDfcAa1rCuKMPZHWpQIFQFJNUGnd26K48xop5zM5GbHXi9ujM+nApBn7SGD6M3xS0o
        W8k1bxUQfgLvtC0oqutGEwnbq3eeA6A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-QPuIA2v-OYO_laQDjnc4Kw-1; Sat, 25 Sep 2021 21:42:13 -0400
X-MC-Unique: QPuIA2v-OYO_laQDjnc4Kw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D776835DE1;
        Sun, 26 Sep 2021 01:42:12 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8395810023AE;
        Sun, 26 Sep 2021 01:41:59 +0000 (UTC)
Date:   Sun, 26 Sep 2021 09:42:14 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        hare@suse.de
Subject: Re: [PATCH v4 07/13] blk-mq: Pass driver tags to
 blk_mq_clear_rq_mapping()
Message-ID: <YU/P9hoDoSJnoJ4y@T590>
References: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
 <1632472110-244938-8-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1632472110-244938-8-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 24, 2021 at 04:28:24PM +0800, John Garry wrote:
> Function blk_mq_clear_rq_mapping() will be used for shared sbitmap tags
> in future, so pass a driver tags pointer instead of the tagset container
> and HW queue index.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

