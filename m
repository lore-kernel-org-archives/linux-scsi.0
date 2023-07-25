Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8F4C001DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 17:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbjGYRat (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 13:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbjGYRar (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 13:30:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1F519B4
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 10:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690306199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K3k9smGmZF7m5VBPVQUcu3HaBfspP9qLCOq38eKmMNY=;
        b=ZqD+2lAEXyPekgm/uT+k4z6KkQeCfAkgHbSzHAUh3d0vZzV+oxTSnC9nRdEm7LkXLu79Lq
        /YM6zSQ7vPMYvI5uQhhB5arGr6A9BiXZfVu6KMhwfM7cFQ7IfS6twqQkjEADk+WVx6D7wr
        hwez7A/EjXtvj3NunAbR4wmoOfyrKrI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-LYJb3y7xPD60H43QWqTz6w-1; Tue, 25 Jul 2023 13:29:55 -0400
X-MC-Unique: LYJb3y7xPD60H43QWqTz6w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D3A5104458F;
        Tue, 25 Jul 2023 17:29:54 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (unknown [10.2.16.250])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52DED4094DC0;
        Tue, 25 Jul 2023 17:29:53 +0000 (UTC)
Date:   Tue, 25 Jul 2023 10:29:51 -0700
From:   Chris Leech <cleech@redhat.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     lduncan@suse.com, michael.christie@oracle.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, haowenchao@huawei.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] scsi: iscsi: Remove unused extern declaration
 iscsi_lookup_iface()
Message-ID: <ZMAGj/yb5XrcPq5d@rhel-developer-toolbox-latest>
References: <20230725141531.10424-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725141531.10424-1-yuehaibing@huawei.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 25, 2023 at 10:15:31PM +0800, YueHaibing wrote:
> This is not used anymore, so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Thanks,

Reviewed-by: Chris Leech <cleech@redhat.com>

