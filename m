Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E64C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 18:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DF7120818
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 18:33:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ijZ5hRWd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfKLSdF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 13:33:05 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54388 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725997AbfKLSdF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Nov 2019 13:33:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573583583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hOngMvB/JVqKrVOe2rVRrVQXb7pE8yP+FVcMyEr87FQ=;
        b=ijZ5hRWdot+iCyqYpkcxN9dj+CUgtBlNyoTV3z0J3QYiVzILyNSpXX1iat7gFssIdxhOyj
        m/PdJ0L609roAIwBnq2YiGyhtIbC4d8xCvFLRHVzEOChR01E0WB9gfNFDrBsDTPkQ0W3Du
        sU8X4qbcWBYGQi7O8gajgqRpYFZCOks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-9YGXBzWpMeaTLej7Xb_K1A-1; Tue, 12 Nov 2019 13:33:00 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90BBB86A064;
        Tue, 12 Nov 2019 18:32:59 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F1D3101E59D;
        Tue, 12 Nov 2019 18:32:59 +0000 (UTC)
Message-ID: <296200e15187caaca6061434b740bdf440f147b0.camel@redhat.com>
Subject: Re: [PATCH 6/6] lpfc: Update lpfc version to 12.6.0.2
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>
Date:   Tue, 12 Nov 2019 13:32:58 -0500
In-Reply-To: <20191111230401.12958-7-jsmart2021@gmail.com>
References: <20191111230401.12958-1-jsmart2021@gmail.com>
         <20191111230401.12958-7-jsmart2021@gmail.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 9YGXBzWpMeaTLej7Xb_K1A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2019-11-11 at 15:04 -0800, James Smart wrote:
> Update lpfc version to 12.6.0.2
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_version.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_ve=
rsion.h
> index 1532390770f5..9e5ff58edaca 100644
> --- a/drivers/scsi/lpfc/lpfc_version.h
> +++ b/drivers/scsi/lpfc/lpfc_version.h
> @@ -20,7 +20,7 @@
>   * included with this package.                                     *
>   *******************************************************************/
> =20
> -#define LPFC_DRIVER_VERSION "12.6.0.1"
> +#define LPFC_DRIVER_VERSION "12.6.0.2"
>  #define LPFC_DRIVER_NAME=09=09"lpfc"
> =20
>  /* Used for SLI 2/3 */

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

