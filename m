Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB8DC433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Apr 2022 01:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240456AbiDICAM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 22:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240454AbiDICAI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 22:00:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 239D933E80
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 18:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649469482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ySsUJt1TK8qDxnC7VJhqxfa1kvCS0hhCtLwal3lU6zo=;
        b=OJcRwUFhaynsDawK9aDPlalRxAASA+0BQIpINqfbEdRcS5ITB60+2xx5Hq4n6c7PmifPlS
        jxFXgCD5rEZgdNJiSvUcrF32rC0aSaKxx+SmaE5LjJsppQKIBdRNpOFT+rvck3zRiVtb0b
        gWO0yQ6UnK0iW4SQ4njz+HiOJTi5kig=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-jNQ-VzMqNrO4iCHmGFTHkQ-1; Fri, 08 Apr 2022 21:57:58 -0400
X-MC-Unique: jNQ-VzMqNrO4iCHmGFTHkQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 294101C04B62;
        Sat,  9 Apr 2022 01:57:58 +0000 (UTC)
Received: from localhost (unknown [10.2.16.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B825141512C;
        Sat,  9 Apr 2022 01:57:57 +0000 (UTC)
Date:   Fri, 8 Apr 2022 18:57:55 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH 10/10] scsi: iscsi: Add Mike Christie as co-maintainer
Message-ID: <YlDoI96DG7yEbzXn@localhost>
Mail-Followup-To: Mike Christie <michael.christie@oracle.com>,
        skashyap@marvell.com, lduncan@suse.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-11-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408001314.5014-11-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 07, 2022 at 07:13:14PM -0500, Mike Christie wrote:
> I've been doing a lot of iscsi patches because Oracle is paying me to work
> on iSCSI again. It was supposed to be temp assignment, but my co-worker
> that was working on iscsi moved to a new group so it looks like I'm back
> on this code again. After talking to Chris and Lee this patch adds me back
> as co-maintainer, so I can help them and people remember to cc me on
> issues.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
 
Acked-by: Chris Leech <cleech@redhat.com>

> diff --git a/MAINTAINERS b/MAINTAINERS
> index fd768d43e048..ca9d56121974 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10369,6 +10369,7 @@ F:	include/linux/isapnp.h
>  ISCSI
>  M:	Lee Duncan <lduncan@suse.com>
>  M:	Chris Leech <cleech@redhat.com>
> +M:	Mike Christie <michael.christie@oracle.com>
>  L:	open-iscsi@googlegroups.com
>  L:	linux-scsi@vger.kernel.org
>  S:	Maintained
> -- 
> 2.25.1
> 

