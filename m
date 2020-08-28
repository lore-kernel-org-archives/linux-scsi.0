Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D664C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 10:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D88E32078A
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 10:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598608842;
	bh=sqJqYmGsrcZElJ0eIt1DDvGzLzBOscBm1LDUda7F5RM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=cJ6RgB9+xZweKcMnVrfGpIYFvywXhGnevgHKW0Ul6+kZGfzMopCdjI6Vi2y9ctOfl
	 sZORFOLow1/BGyr/Poaq6PjRtVd8E+GuD56A/NTdeUXVQQdVahkHpzZT7xpf6i6aOB
	 WKs1iY7qXAMFoulAH/RQ8Nt1ExVAqy8j/6ab1ipE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgH1KAm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 06:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbgH1KAh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Aug 2020 06:00:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84FA42078A;
        Fri, 28 Aug 2020 10:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598608836;
        bh=sqJqYmGsrcZElJ0eIt1DDvGzLzBOscBm1LDUda7F5RM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i31hSp8bPrdNGQNpJQZSoFNam+AFIlE7FvuXcZYibC9fo602ow06v4rMVY6EGkeP1
         iyxDeKCu79LIBm/3hceUgb0KbtjAZsXD4sTsA1oC9NyuyVKEHXJc2jkEd0rt+lsFpO
         YwUexOu8ydV13OE4YzmS9q3gz0Lt/7aAWnVq5Xoo=
Date:   Fri, 28 Aug 2020 12:00:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        linux-spdx@vger.kernel.org, linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com,
        Arun Easi <aeasi@marvell.com>
Subject: Re: [PATCH] MAINTAINERS: orphan sections with qlogic.com group alias
Message-ID: <20200828100048.GA1229122@kroah.com>
References: <20200828070824.8032-1-lukas.bulwahn@gmail.com>
 <20200828091758.GF54274@SPB-NB-133.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200828091758.GF54274@SPB-NB-133.local>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 28, 2020 at 12:17:58PM +0300, Roman Bolshakov wrote:
> On Fri, Aug 28, 2020 at 09:08:24AM +0200, Lukas Bulwahn wrote:
> > Previous attempts of getting an answer from the qlogic.com group alias,
> > i.e., QLogic-Storage-Upstream@qlogic.com, have remained unanswered; see
> > links below.
> > 
> > Mark those sections Orphan to prepare their deletion or give an actual
> > person a chance to step up to maintain those drivers.
> > 
> > Link: https://lore.kernel.org/linux-spdx/20190606205526.447558989@linutronix.de
> > Link: https://lore.kernel.org/linux-spdx/alpine.DEB.2.21.2006300644130.4919@felia
> > Link: https://lore.kernel.org/linux-spdx/alpine.DEB.2.21.2008270740140.31123@felia
> > 
> > Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > ---
> > applies cleanly on current master and next-20200828
> > 
> > James, Martin, please pick this minor non-urgent patch.
> > 
> > Anil, Sudarsana, if these drivers are still maintained by qlogic, please
> > provide actual names of people that maintain these drivers.
> > 
> >  MAINTAINERS | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 3b186ade3597..415058b48a2e 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -3507,15 +3507,13 @@ F:	drivers/net/ethernet/broadcom/bnx2.*
> >  F:	drivers/net/ethernet/broadcom/bnx2_*
> >  
> >  BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER
> > -M:	QLogic-Storage-Upstream@qlogic.com
> >  L:	linux-scsi@vger.kernel.org
> > -S:	Supported
> > +S:	Orphan
> >  F:	drivers/scsi/bnx2fc/
> >  
> >  BROADCOM BNX2I 1/10 GIGABIT iSCSI DRIVER
> > -M:	QLogic-Storage-Upstream@qlogic.com
> >  L:	linux-scsi@vger.kernel.org
> > -S:	Supported
> > +S:	Orphan
> >  F:	drivers/scsi/bnx2i/
> >  
> >  BROADCOM BNX2X 10 GIGABIT ETHERNET DRIVER
> > @@ -14212,9 +14210,8 @@ F:	Documentation/networking/device_drivers/ethernet/qlogic/LICENSE.qla3xxx
> >  F:	drivers/net/ethernet/qlogic/qla3xxx.*
> >  
> >  QLOGIC QLA4XXX iSCSI DRIVER
> > -M:	QLogic-Storage-Upstream@qlogic.com
> >  L:	linux-scsi@vger.kernel.org
> > -S:	Supported
> > +S:	Orphan
> >  F:	Documentation/scsi/LICENSE.qla4xxx
> >  F:	drivers/scsi/qla4xxx/
> >  
> > -- 
> > 2.17.1
> > 
> 
> CC'd Arun,
> 
> I think it's worth to update the alias to:
> 
> GR-QLogic-Storage-Upstream@marvell.com

Again, no, please remove aliases and use real names and email addresses,
otherwise accountability is lost over time, as we have seen constantly.

thanks,

greg k-h
