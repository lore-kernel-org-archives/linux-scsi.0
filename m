Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 043FCC7EE22
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 00:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjERAAS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 20:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjERAAR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 20:00:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FA8DB
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 16:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684367969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zaAw3DfruQqVK9HMPFMNTD+vmz7lKsGTCrArzNfkgXE=;
        b=QxhJj/v9mZCuixOJzdzgi0NVNZdwxlBrfJZF6Z9OsIc6iH/Z15PZ7EVlluQUDhYQFZBmx+
        AAyKtbaSqMxgeqCMLSIbB1hLJ/FRsiFgaLdWWmD4RgZuu+Pygl31SC/NLFr3bfIXstk2Xk
        34BafZt+/+GHETzxNGwT70rhBZuZpjs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-mmyuWlg1NuygLcC0g-tDqQ-1; Wed, 17 May 2023 19:59:19 -0400
X-MC-Unique: mmyuWlg1NuygLcC0g-tDqQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2994867942;
        Wed, 17 May 2023 23:59:18 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E626F492B00;
        Wed, 17 May 2023 23:59:14 +0000 (UTC)
Date:   Thu, 18 May 2023 07:59:09 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Ye Bin <yebin10@huawei.com>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 1/4] scsi: core: Rework scsi_host_block()
Message-ID: <ZGVqTQZ1CWdH2Hng@ovpn-8-16.pek2.redhat.com>
References: <20230517222359.1066918-1-bvanassche@acm.org>
 <20230517222359.1066918-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517222359.1066918-2-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 17, 2023 at 03:23:56PM -0700, Bart Van Assche wrote:
> Make scsi_host_block() easier to read by converting it to the widely used
> early-return style. See also commit f983622ae605 ("scsi: core: Avoid
> calling synchronize_rcu() for each device in scsi_host_block()").
> 
> Reviewed-by: Mike Christie <michael.christie@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Ye Bin <yebin10@huawei.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming

