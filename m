Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E24C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 15:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6964B22B3F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 15:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgLIPpM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 10:45:12 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:43921
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728082AbgLIPpM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 10:45:12 -0500
X-IronPort-AV: E=Sophos;i="5.78,405,1599516000"; 
   d="scan'208";a="367056589"
Received: from 173.121.68.85.rev.sfr.net (HELO hadrien) ([85.68.121.173])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 16:44:29 +0100
Date:   Wed, 9 Dec 2020 16:44:29 +0100 (CET)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     John Garry <john.garry@huawei.com>
cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: Re: problem booting 5.10
In-Reply-To: <4f3cd4d4-87d3-dc9a-027d-293cba469d5a@huawei.com>
Message-ID: <alpine.DEB.2.22.394.2012091644010.2691@hadrien>
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien> <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com> <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com> <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
 <9106e994-bb4b-4148-1280-f08f71427420@huawei.com> <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com> <alpine.DEB.2.22.394.2012082339470.16458@hadrien> <yq1sg8fud7y.fsf@ca-mkp.ca.oracle.com>
 <4f3cd4d4-87d3-dc9a-027d-293cba469d5a@huawei.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On Tue, 8 Dec 2020, John Garry wrote:

> On 08/12/2020 22:51, Martin K. Petersen wrote:
> >
> > Julia,
> >
> > > This solves the problem.  Starting from 5.10-rc7 and doing this revert, I
> > > get a kernel that boots.
> >
>
> Hi Julia,
>
> Can you also please test Ming's patchset here (without the megaraid sas
> revert) when you get a chance:
> https://lore.kernel.org/linux-block/20201203012638.543321-1-ming.lei@redhat.com/

5.10-rc7 plus these three commits boots fine.

thanks,
julia

>
> And please also share your .config, as I guess that it is not mainline vanilla
> and we will want to recreate this to be sure for future. Qian's issue was only
> exposed with a specific .config enabling lots of heavy debug options.
>
> Thanks,
> John
>
> > Thanks for testing!
> >
> > I'll go ahead and revert 103fbf8e4020 in 5.10/scsi-fixes. We can revisit
> > this change in 5.11 when Ming's fixes are in place.
> >
>
