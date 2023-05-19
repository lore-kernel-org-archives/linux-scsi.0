Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1A8C7EE2A
	for <linux-scsi@archiver.kernel.org>; Fri, 19 May 2023 07:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjESHEE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 May 2023 03:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjESHED (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2023 03:04:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DDEE73
        for <linux-scsi@vger.kernel.org>; Fri, 19 May 2023 00:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684479796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=089CE+5hhdiEgCOACPwfkq5NJunF4/L0Hh/3kGYN7Ak=;
        b=WCQ3hdU2ZEsh36lvjR0VI6tf+h7Hy6TSOTFkHTvIzfH0rBcwwwiHcHpNHm9CLKOvlkDEd3
        7VztMV7bqZKA0iCSf4qlOM3au+AqjgUmHiX7DI+IeJR6DEwVT3agswiRpIu+HeGLsR5YWt
        jGhnHHUstF2EBdMW6pC8Lm1fSZ5A+S8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-HJ18yhLOPPCBfqXUuw85YA-1; Fri, 19 May 2023 03:03:14 -0400
X-MC-Unique: HJ18yhLOPPCBfqXUuw85YA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 121163C10EC3;
        Fri, 19 May 2023 07:03:14 +0000 (UTC)
Received: from ovpn-8-21.pek2.redhat.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 663451410DD5;
        Fri, 19 May 2023 07:03:09 +0000 (UTC)
Date:   Fri, 19 May 2023 15:03:04 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH v4 2/3] scsi: core: Trace SCSI sense data
Message-ID: <ZGcfKBYhOYz1gsf6@ovpn-8-21.pek2.redhat.com>
References: <20230518193159.1166304-1-bvanassche@acm.org>
 <20230518193159.1166304-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518193159.1166304-3-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 18, 2023 at 12:31:58PM -0700, Bart Van Assche wrote:
> If a command fails, SCSI sense data is essential to determine why it
> failed. Hence make the sense key, ASC and ASCQ codes available in the
> ftrace output.
> 
> Cc: Niklas Cassel <niklas.cassel@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming

