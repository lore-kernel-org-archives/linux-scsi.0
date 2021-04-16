Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A4FC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 21:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4538B613D2
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 21:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344396AbhDPVZt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 17:25:49 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:39036 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344375AbhDPVZp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2021 17:25:45 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 15A7692009C; Fri, 16 Apr 2021 23:25:19 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 12B4892009B;
        Fri, 16 Apr 2021 23:25:19 +0200 (CEST)
Date:   Fri, 16 Apr 2021 23:25:18 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Khalid Aziz <khalid@gonehiking.org>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Bring the BusLogic host bus adapter driver up to
 Y2021
In-Reply-To: <a099f7f8-9601-fd1c-03a4-93587e7276e6@gonehiking.org>
Message-ID: <alpine.DEB.2.21.2104162157360.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk> <a099f7f8-9601-fd1c-03a4-93587e7276e6@gonehiking.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 16 Apr 2021, Khalid Aziz wrote:

> >  Sadly I didn't get to these resources while they were still there, and 
> > neither did archive.org, and now they not appear available from anywhere 
> > online.  I'm sure Leonard had this all, but, alas, he is long gone too.
> 
> These documents were all gone by the time I started working on this
> driver in 2013.

 According to my e-mail archives I got my BT-958 directly from Mylex brand 
new as KT-958 back in early 1998 (the rest of the system is a bit older).  
It wasn't up until 2003 when I was caught by the issue with the LOG SENSE 
command that I got interested in the programming details of the adapter.  

 At that time Mylex was in flux already, having been bought by LSI shortly 
before.  Support advised me what was there at Leonard's www.dandelion.com 
site was all that was available (I have a personal copy of the site) and 
they would suggest to switch to their current products.  So it was too 
late already ten years before you got at the driver.

 I'll yet double-check the contents of the KT-958 kit which I have kept, 
but if there was any technical documentation supplied there on a CD (which 
I doubt), I would have surely discovered it earlier.  It's away along with 
the server, remotely managed, ~160km/100mi from here, so it'll be some 
time before I get at it though.

 Still, maybe one of the SCSI old-timers has that stuff stashed somewhere.  
I have plenty of technical documentation going back to early to mid 1990s 
(some in the hard copy form), not necessarily readily available nowadays. 
Sadly lots of such stuff goes offline or is completely lost to the mist of 
time.

  Maciej
