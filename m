Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 075CBC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jul 2022 08:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbiGTIj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jul 2022 04:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiGTIj2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2022 04:39:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0ADF450045
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2022 01:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658306367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wlMH5g2pYYdVhxWcCiqJMHzm6/EnXH4v1zhevt16ax4=;
        b=E54e+rMg+mNPl5y2uDNT4jZblCMIDe991l1+GwRU67j2dS95s8xWYdUUE4lTwXLozZJFV7
        vQtLLgtjL8C7J6cPZoiTZ+qHvx9nP+Ue2ArsJEk4MiSftK09NtOHdTFdQq5MWKnUAkYc84
        VB02jKeY2CpRjX8izTCqC0k6qkZ2Fzc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-3bqPEGlvOT6zWw1kCmwQAQ-1; Wed, 20 Jul 2022 04:39:23 -0400
X-MC-Unique: 3bqPEGlvOT6zWw1kCmwQAQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 618E58001EA;
        Wed, 20 Jul 2022 08:39:23 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E839518EA8;
        Wed, 20 Jul 2022 08:39:20 +0000 (UTC)
Date:   Wed, 20 Jul 2022 16:39:16 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Tasmiya Nalatwad <tasmiya@linux.vnet.ibm.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [linux-next] [5.19.0-rc1] kernel crashes while performing driver
 bind/unbind test with SLUB_DEBUG enabled
Message-ID: <Yte/INnQsKESNPQu@T590>
References: <c1846219-cea9-e82c-7337-6f6d9ffadd3d@linux.vnet.ibm.com>
 <Yqksbtth8zzEmjp4@T590>
 <d789d8f6-71c3-3927-7708-141b43c3ba0b@linux.vnet.ibm.com>
 <Ys7EXeoVbLRZj9CL@T590>
 <59642c8d-adbf-cbfd-ffee-3f3b31613e05@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59642c8d-adbf-cbfd-ffee-3f3b31613e05@linux.vnet.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 20, 2022 at 01:49:25PM +0530, Tasmiya Nalatwad wrote:
> Greetings,
> 
> Sure I will verify, could you please provide me the code patch.

Oh, sorry for not providing link for you, please try the following
patches:

https://lore.kernel.org/linux-scsi/20220712221936.1199196-1-bvanassche@acm.org/T/#t


Thanks,
Ming

