Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A222C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 09:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27481208FE
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 09:18:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="YxmGdsnf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgH1JSF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 05:18:05 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:44978 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbgH1JSD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Aug 2020 05:18:03 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 6B7EB5754C;
        Fri, 28 Aug 2020 09:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1598606279;
         x=1600420680; bh=PUk//xOzd/M0oYjICwsVKn2q7OnTIXAG1A0ffeeY6Wg=; b=
        YxmGdsnf9SqRx7b08HVZC6O61XFt1CNpKrRF02a1iD4LWquzPgpaaRxBfSQuuLW2
        pWO34ze7GIjsOSTG11r+UsRZr2hJVdHQGAwlM6iR2KoLGKpZxPAGi79v28eMDwlN
        hK5VaG5f22UwDfGl5mCsBK+U8M2MN2283e/sYhsxDy0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RnCPCZ0Ln2Q9; Fri, 28 Aug 2020 12:17:59 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 781195753E;
        Fri, 28 Aug 2020 12:17:59 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 28
 Aug 2020 12:17:59 +0300
Date:   Fri, 28 Aug 2020 12:17:58 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
CC:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        <linux-spdx@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Arun Easi <aeasi@marvell.com>
Subject: Re: [PATCH] MAINTAINERS: orphan sections with qlogic.com group alias
Message-ID: <20200828091758.GF54274@SPB-NB-133.local>
References: <20200828070824.8032-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200828070824.8032-1-lukas.bulwahn@gmail.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 28, 2020 at 09:08:24AM +0200, Lukas Bulwahn wrote:
> Previous attempts of getting an answer from the qlogic.com group alias,
> i.e., QLogic-Storage-Upstream@qlogic.com, have remained unanswered; see
> links below.
> 
> Mark those sections Orphan to prepare their deletion or give an actual
> person a chance to step up to maintain those drivers.
> 
> Link: https://lore.kernel.org/linux-spdx/20190606205526.447558989@linutronix.de
> Link: https://lore.kernel.org/linux-spdx/alpine.DEB.2.21.2006300644130.4919@felia
> Link: https://lore.kernel.org/linux-spdx/alpine.DEB.2.21.2008270740140.31123@felia
> 
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> applies cleanly on current master and next-20200828
> 
> James, Martin, please pick this minor non-urgent patch.
> 
> Anil, Sudarsana, if these drivers are still maintained by qlogic, please
> provide actual names of people that maintain these drivers.
> 
>  MAINTAINERS | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3b186ade3597..415058b48a2e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3507,15 +3507,13 @@ F:	drivers/net/ethernet/broadcom/bnx2.*
>  F:	drivers/net/ethernet/broadcom/bnx2_*
>  
>  BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER
> -M:	QLogic-Storage-Upstream@qlogic.com
>  L:	linux-scsi@vger.kernel.org
> -S:	Supported
> +S:	Orphan
>  F:	drivers/scsi/bnx2fc/
>  
>  BROADCOM BNX2I 1/10 GIGABIT iSCSI DRIVER
> -M:	QLogic-Storage-Upstream@qlogic.com
>  L:	linux-scsi@vger.kernel.org
> -S:	Supported
> +S:	Orphan
>  F:	drivers/scsi/bnx2i/
>  
>  BROADCOM BNX2X 10 GIGABIT ETHERNET DRIVER
> @@ -14212,9 +14210,8 @@ F:	Documentation/networking/device_drivers/ethernet/qlogic/LICENSE.qla3xxx
>  F:	drivers/net/ethernet/qlogic/qla3xxx.*
>  
>  QLOGIC QLA4XXX iSCSI DRIVER
> -M:	QLogic-Storage-Upstream@qlogic.com
>  L:	linux-scsi@vger.kernel.org
> -S:	Supported
> +S:	Orphan
>  F:	Documentation/scsi/LICENSE.qla4xxx
>  F:	drivers/scsi/qla4xxx/
>  
> -- 
> 2.17.1
> 

CC'd Arun,

I think it's worth to update the alias to:

GR-QLogic-Storage-Upstream@marvell.com
