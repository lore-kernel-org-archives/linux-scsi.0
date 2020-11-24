Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B1CC2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 23:23:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 489F52100A
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 23:23:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gMm5XZ/Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387793AbgKXXXV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 18:23:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22895 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387688AbgKXXXU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Nov 2020 18:23:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606260199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=juO2ukM0vWEz2TyhMweuiHZkMxI8vTNzyetnn/4z4BE=;
        b=gMm5XZ/QMu3/sHx9DqrbOyRVqWdWGE/TkpaFSAPSYJA9tYQ0dqmsEdNN6QjXcro0wB7WEK
        wjeMT2xdfvXPI1L41qD+uKS2KaocG8s4YTWZpJdH9yZXMxTdRmoadnxBljgvWbGlPJidWg
        Ubw8/jFnaIxEcupCuvDe528Ft86APFs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-OIAh5lbUNuqNJH_B7lfNAA-1; Tue, 24 Nov 2020 18:23:15 -0500
X-MC-Unique: OIAh5lbUNuqNJH_B7lfNAA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB07680F041;
        Tue, 24 Nov 2020 23:23:13 +0000 (UTC)
Received: from ovpn-112-111.phx2.redhat.com (ovpn-112-111.phx2.redhat.com [10.3.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 541061001E73;
        Tue, 24 Nov 2020 23:23:13 +0000 (UTC)
Message-ID: <b09bdc573715f51117c788a9b02d6b87c9735c4b.camel@redhat.com>
Subject: Re: [PATCH][next] scsi: pm8001: remove space in a debug message
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Colin King <colin.king@canonical.com>, linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 24 Nov 2020 18:23:12 -0500
In-Reply-To: <20201124093828.307709-1-colin.king@canonical.com>
References: <20201124093828.307709-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-11-24 at 09:38 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are two words that need separating with a space in a 
> pm8001_dbg message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
> b/drivers/scsi/pm8001/pm8001_hwi.c
> index 08d6cc9b50db..c8d4d87c5473 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1031,7 +1031,7 @@ pm8001_chip_soft_rst(struct pm8001_hba_info
> *pm8001_ha)
>  	regVal = pm8001_cr32(pm8001_ha, 2,
> GSM_WRITE_DATA_PARITY_CHECK);
>  	pm8001_cw32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK,
> regVal3);
>  	pm8001_dbg(pm8001_ha, INIT,
> -		   "GSM 0x700048 - Write Data Parity Check Enableis set
> to = 0x%x\n",
> +		   "GSM 0x700048 - Write Data Parity Check Enable is
> set to = 0x%x\n",
>  		   pm8001_cr32(pm8001_ha, 2,
> GSM_WRITE_DATA_PARITY_CHECK));
>  
>  	/* step 13: bring the IOP and AAP1 out of reset */

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


