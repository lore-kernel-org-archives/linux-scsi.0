Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE342C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 07:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB6BE20866
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 07:00:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="BUTGHoex"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgHMHAK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Aug 2020 03:00:10 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:42636 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbgHMHAK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Aug 2020 03:00:10 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 37BED4CD1F;
        Thu, 13 Aug 2020 07:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1597302007;
         x=1599116408; bh=nVdzMLjbFowO5EDQNHUmkeB5/piTk3JWXAfC3F2cWrM=; b=
        BUTGHoexsSJkFBX7bq5oTuWd9hvM+PmXKTjg0tFfzSNTeYS8E4HEMq0io53Ba/4W
        wcca9YmpIhiTMaW6qnMzVtShyyFz97I81Wqk641GkO5IIHIejXb9F34GG98QPl6A
        4f+5+i4xbe71WiZkuCodMHjrmTpBdiUDYilRj6HrX0Y=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ssyGS2w9r8eE; Thu, 13 Aug 2020 10:00:07 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9515B4CD1B;
        Thu, 13 Aug 2020 10:00:06 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 13
 Aug 2020 10:00:06 +0300
Date:   Thu, 13 Aug 2020 10:00:05 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Enzo Matsumiya <ematsumiya@suse.de>
CC:     <linux-scsi@vger.kernel.org>, Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: use MBX_TOV_SECONDS for mailbox command
 timeout values
Message-ID: <20200813070005.GC86269@SPB-NB-133.local>
References: <20200805200546.22497-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200805200546.22497-1-ematsumiya@suse.de>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 05, 2020 at 05:05:46PM -0300, Enzo Matsumiya wrote:
> Improves readability of qla_mbx.c
> 
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  drivers/scsi/qla2xxx/qla_mbx.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thanks,
Roman
