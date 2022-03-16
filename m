Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40652C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Mar 2022 01:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352881AbiCPBK3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 21:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351012AbiCPBK2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 21:10:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 062A043EE2
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 18:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647392955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+6Zxpyswx8y2ltjjjqcJtCj5d9tJg3WrGkfj4f0O4JQ=;
        b=K2d7szlljFxekrpl/pDQLgG5JNPpu8sVmvnybg8gcqb74XCEyQJS7ZLxmCPlXauEz037/R
        XNGAUXrNc8VEf073o3QwURCt+mfbpsou3rbAdd0rAHStf/j0A0eZc2Wkou9JPYAS4ODdX8
        8QdQwx07X/9MqbyFNiz1UaAXrUODzuU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-f8YgJxp-Mk-ipaxtPBQhyQ-1; Tue, 15 Mar 2022 21:09:11 -0400
X-MC-Unique: f8YgJxp-Mk-ipaxtPBQhyQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 537592A59545;
        Wed, 16 Mar 2022 01:09:11 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 63E2A215688A;
        Wed, 16 Mar 2022 01:09:00 +0000 (UTC)
Date:   Wed, 16 Mar 2022 09:08:55 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, lduncan@suse.com, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [RFC PATCH 0/4] scsi/iscsi: Send iscsi data from kblockd
Message-ID: <YjE4p4qlNgd0TyVM@T590>
References: <20220308003957.123312-1-michael.christie@oracle.com>
 <YjBNwMp3WlkjFd0g@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjBNwMp3WlkjFd0g@infradead.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 15, 2022 at 01:26:40AM -0700, Christoph Hellwig wrote:
> The subject seems a bit misleading, I'd expect to see
> BLK_MQ_F_BLOCKING in the subject.
> 
> Note that you'll also need the series from Ming to support dm-multipath
> on top devices that set BLK_MQ_F_BLOCKING.

Indeed.

Mike, please feel free to fold the following patches into your next
post:

https://lore.kernel.org/linux-block/YcP4FMG9an5ReIiV@T590/#r


Thanks, 
Ming

