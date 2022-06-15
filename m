Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBF9C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jun 2022 00:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239536AbiFOAuX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jun 2022 20:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239399AbiFOAuU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2022 20:50:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8EC44C424
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2022 17:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655254218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xe0eaQQFLlAHWT6CZmQyGkhuBrtnIKCUeYmFJjANHY4=;
        b=B/dLdVlQ5JQ/SbONG2pey28y2qN559bi/h8op0INzWQjCrXNS3aQ0G79L+0wgFDEejJk9t
        fo6yUdsMclDeqFHlELpkGILdkoH+Xy5pGXkcddGh9ifxm/e2GJWcNtH5jTGlZVn5PgU/Li
        aUFrZRJMiW/tEuy5pojUIkLQ2Bar0YU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-CQW5-hgCOb2d5HOCGHoomQ-1; Tue, 14 Jun 2022 20:50:15 -0400
X-MC-Unique: CQW5-hgCOb2d5HOCGHoomQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3003C85A581;
        Wed, 15 Jun 2022 00:50:15 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 15EC940EC002;
        Wed, 15 Jun 2022 00:50:10 +0000 (UTC)
Date:   Wed, 15 Jun 2022 08:50:05 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Tasmiya Nalatwad <tasmiya@linux.vnet.ibm.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        abdhalee@linux.vnet.ibm.com, ming.lei@redhat.com
Subject: Re: [linux-next] [5.19.0-rc1] kernel crashes while performing driver
 bind/unbind test with SLUB_DEBUG enabled
Message-ID: <Yqksbtth8zzEmjp4@T590>
References: <c1846219-cea9-e82c-7337-6f6d9ffadd3d@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1846219-cea9-e82c-7337-6f6d9ffadd3d@linux.vnet.ibm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Tasmiya,

On Tue, Jun 14, 2022 at 03:27:37PM +0530, Tasmiya Nalatwad wrote:
> Greetings,
> 
> [linux-next] [5.19.0-rc1-next-20220610] kernel crashes while performing
> driver bind/unbind test with SLUB_DEBUG enabled
> 
> Traces :

I just run plain unbind/bind on scsi_debug, and can't trigger the issue.

Can you share your exact reproduction steps? Is dm-mpath involved?


Thanks,
Ming

