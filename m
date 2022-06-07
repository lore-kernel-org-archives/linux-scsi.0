Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CD2C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 14:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245075AbiFGOD5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 10:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244005AbiFGOD4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 10:03:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0B4A5E16E
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 07:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654610634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XWoeJ1CjPoJt96h4eLMWqdTk9yFlWakBAEpC46UOYJo=;
        b=iXUY+uA1Fp23Rzy/nfcrtYjOR60CuWAf7taGdwb42FC7EFhMjCbGLBCBhXBsFhiFwpSb03
        48tmAz/adUkU4LPIhmm7PK0JaJ+30L+qb4WGW5140dR464gYO8IsiEh3suDyHu9Fd9KTZF
        cjUXAFmGFaEQ7S72b1GU/6i24dycywA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-KTAA5WdwNBOptCanjpvs8g-1; Tue, 07 Jun 2022 10:03:51 -0400
X-MC-Unique: KTAA5WdwNBOptCanjpvs8g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13142801756;
        Tue,  7 Jun 2022 14:03:51 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0177A1121314;
        Tue,  7 Jun 2022 14:03:45 +0000 (UTC)
Date:   Tue, 7 Jun 2022 22:03:40 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Ismael Luceno <iluceno@suse.de>
Cc:     Enzo Matsumiya <ematsumiya@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 4/5] nvme: quiesce namespace queue in parallel
Message-ID: <Yp9avMfGDsOLIXeG@T590>
References: <20211130073752.3005936-1-ming.lei@redhat.com>
 <20220607132118.0bbb230b@pirotess>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607132118.0bbb230b@pirotess>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 07, 2022 at 01:21:18PM +0200, Ismael Luceno wrote:
> Hi Ming,
> 
> Has this patch been dropped/abandoned?

Hi Ismael,

The whole patchset wasn't be accepted if I remember correctly, but
finally we moved srcu out of hctx in another patchset.

If you think the patch of 'nvme: quiesce namespace queue in parallel'
is useful, please provide a bit info about your case, then we may
figure out similar patch if it is necessary.


Thanks,
Ming

