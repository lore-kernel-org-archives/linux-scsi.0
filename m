Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4ED9C5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C48121929
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:21:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z9T5/Vy/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389836AbfKEPVo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:21:44 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38549 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389634AbfKEPVo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:21:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572967303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DO+7bw9TAa9GUX8FLdJ1rAU1L2JpKmwKzXPhfpwxNtE=;
        b=Z9T5/Vy/l7/cJbk/aQnQQ0/NOvlfO2D063IINLNFD642oQrPR8qnHCDfbEjT1mRnaLgrEU
        lospItAds1CKoPyhZJaP3z4hCUZi6oRvaAOZ+9gQEW59pj/vlz65hq6MXnZt/3kOrfEhJI
        LWCATJZYKKlJMo6qJaRuoUgPZ6KFGkY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-q81Les-WN72Xmq2JO9YB8Q-1; Tue, 05 Nov 2019 10:21:39 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 655698017DD;
        Tue,  5 Nov 2019 15:21:38 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCF86608B4;
        Tue,  5 Nov 2019 15:21:37 +0000 (UTC)
Message-ID: <6e90a4b82537efcbbd37fdc336184f4c8cfb5874.camel@redhat.com>
Subject: Re: [PATCH 8/8] qla2xxx: Update driver version to 10.01.00.21-k
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Tue, 05 Nov 2019 10:21:37 -0500
In-Reply-To: <20191105150657.8092-9-hmadhani@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
         <20191105150657.8092-9-hmadhani@marvell.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: q81Les-WN72Xmq2JO9YB8Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2019-11-05 at 07:06 -0800, Himanshu Madhani wrote:
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_version.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/ql=
a_version.h
> index 225e401b62fa..03bd3b712b77 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -7,7 +7,7 @@
>  /*
>   * Driver version
>   */
> -#define QLA2XXX_VERSION      "10.01.00.20-k"
> +#define QLA2XXX_VERSION      "10.01.00.21-k"
> =20
>  #define QLA_DRIVER_MAJOR_VER=0910
>  #define QLA_DRIVER_MINOR_VER=091

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

