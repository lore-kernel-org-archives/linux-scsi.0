Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C2F0C54EE9
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 08:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiIHIja (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 04:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiIHIjT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 04:39:19 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EB6112E43;
        Thu,  8 Sep 2022 01:39:18 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 088DB44B1B;
        Thu,  8 Sep 2022 08:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1662626355; x=1664440756; bh=gJybNLxkrdA9/Sd4hOvjupmPM3dFiBVQUj/
        HbJ5cj5I=; b=opQmWqcKy8F2j8bQdgjbRCrx6e1oCTbx0ugYeafwtUuxecOPbX+
        LbFPtd5M6EL4+uSqJN1lwssFJD4ZFW6aq9uVI1cSb32hL1kZ+Uedenml9SYDOKPr
        VcY1A/HGLGh+I5hfe4Poz1Yl8SMB0sxAwAQVRQhPHSPb85ykuTNdLzY0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kMeUtALw46wW; Thu,  8 Sep 2022 11:39:15 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 0CA2744F8B;
        Thu,  8 Sep 2022 11:39:15 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 8 Sep 2022 11:39:14 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 8 Sep 2022
 11:39:14 +0300
Date:   Thu, 8 Sep 2022 11:39:14 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH 4/4] target: core: new key must be used for moved PR
Message-ID: <20220908083914.GB9218@yadro.com>
References: <20220907135851.3756-1-d.bogdanov@yadro.com>
 <20220907135851.3756-5-d.bogdanov@yadro.com>
 <73091ce3-5412-b3f8-94c5-c6224ffcc08c@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <73091ce3-5412-b3f8-94c5-c6224ffcc08c@acm.org>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 07, 2022 at 09:19:46AM -0700, Bart Van Assche wrote:
> 
> On 9/7/22 06:58, Dmitry Bogdanov wrote:
> > +     } else {
> > +     /*
> > +      * e) Retain the reservation key specified in the SERVICE ACTION
> > +      *    RESERVATION KEY field and associated information;
> > +      */
> > +             dest_pr_reg->pr_res_key = sa_res_key;
> >       }
> 
> The indentation of the new comment looks wrong to me. Please fix.
Oh, yes, forgot to add a tab there.

BR,
 Dmitry 
