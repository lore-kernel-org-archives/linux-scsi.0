Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2835C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 03:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D720B60FDA
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 03:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbhHRD4u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 23:56:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47934 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236664AbhHRD4t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 23:56:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629258975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZQHYMXJcgCjoNKEEL5x5yhztahB+htLkxP7MwFCB/4Y=;
        b=CgI6jIaJKcxf86grMbwoaGCbpaXONFO3f4rNc8es5SaT+fF8VBk1e9JJQkOdPNVItb+ACA
        4krsAUd4mmS+es8DKbG8oTCuvubiFiz7Y0E+ZP2ZDs/K7KPYYIEG3rp9anHlx9YIfdXKKy
        P/vi2wsxjqT3CAA07xx1ChvK7YRu+lg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-_i89I_Y3OXKRiu44R7to6A-1; Tue, 17 Aug 2021 23:56:14 -0400
X-MC-Unique: _i89I_Y3OXKRiu44R7to6A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C8D0801AC0;
        Wed, 18 Aug 2021 03:56:12 +0000 (UTC)
Received: from T590 (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E26E19D9D;
        Wed, 18 Aug 2021 03:56:03 +0000 (UTC)
Date:   Wed, 18 Aug 2021 11:55:57 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        hare@suse.de
Subject: Re: [PATCH v2 05/11] blk-mq-sched: Rename blk_mq_sched_alloc_{tags
 -> map_and_request}()
Message-ID: <YRyEzcoou9khUD7S@T590>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
 <1628519378-211232-6-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628519378-211232-6-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 09, 2021 at 10:29:32PM +0800, John Garry wrote:
> Function blk_mq_sched_alloc_tags() does same as
> __blk_mq_alloc_map_and_request(), so give a similar name to be consistent.
> 
> Similarly rename label err_free_tags -> err_free_map_and_request.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

