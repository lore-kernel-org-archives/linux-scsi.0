Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D337C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 01:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4DEA610E8
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 01:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhKCBqy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 21:46:54 -0400
Received: from email.unionmem.com ([221.4.138.186]:18325 "EHLO
        VLXDG1SPAM1.ramaxel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229844AbhKCBqx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 21:46:53 -0400
Received: from V12DG1MBS01.ramaxel.local (v12dg1mbs01.ramaxel.local [172.26.18.31])
        by VLXDG1SPAM1.ramaxel.com with ESMTPS id 1A31hnQp063700
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 3 Nov 2021 09:43:49 +0800 (GMT-8)
        (envelope-from songyl@ramaxel.com)
Received: from songyl (10.64.10.220) by V12DG1MBS01.ramaxel.local
 (172.26.18.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 3
 Nov 2021 09:43:48 +0800
Date:   Wed, 3 Nov 2021 01:43:33 +0000
From:   Yanling Song <songyl@ramaxel.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
Message-ID: <20211103014333.3d57dd24@songyl>
In-Reply-To: <1abeda89-d7cf-9164-d8a1-3c764fd870a4@acm.org>
References: <20210930034752.248781-1-songyl@ramaxel.com>
        <cfe5b692-6642-e317-39a7-f38c1460097c@acm.org>
        <20211012144906.790579d0@songyl>
        <6cd75c09-8374-7b9b-4ecc-3b3781cbe074@acm.org>
        <20211013065012.02b76336@songyl>
        <9d9d2f95-7782-85a7-b79a-ce481292c451@acm.org>
        <20211020003323.61323f67@songyl>
        <1abeda89-d7cf-9164-d8a1-3c764fd870a4@acm.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.10.220]
X-ClientProxiedBy: V12DG1MBS01.ramaxel.local (172.26.18.31) To
 V12DG1MBS01.ramaxel.local (172.26.18.31)
X-DNSRBL: 
X-MAIL: VLXDG1SPAM1.ramaxel.com 1A31hnQp063700
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 19 Oct 2021 20:24:45 -0700
Bart Van Assche <bvanassche@acm.org> wrote:

> On 10/19/21 17:33, Yanling Song wrote:
> > On Wed, 13 Oct 2021 15:00:07 -0700
> > Bart Van Assche <bvanassche@acm.org> wrote:  
> >> Please take a look at the bsg_setup_queue() call in
> >> ufs_bsg_probe(). That call associates a BSG queue with the UFS
> >> host. That queue supports requests of type struct ufs_bsg_request.
> >> The Fibre Channel transport driver does something similar. I
> >> believe that this is a better solution than introducing entirely
> >> new ioctls.  
> > 
> > I wish there was a standard way to address the ioctrl issue.
> > Unfortunately ioctrl is the only way to meet our requirements as
> > listed in the above.
> > As discussed in previous megaraid's patchsets:
> > https://lore.kernel.org/linux-scsi/yq1inc2y019.fsf@oracle.com/,
> > that's why every raid controller has it's own ioctrl.  
> 
> Why are ioctls the only solution? Why is a bsg interface attached to
> the SCSI host not appropriate? I haven't found the answer in the 
> conversation about the Megaraid driver.
> 
I just wanted to let you know that we are working on the feasibility of
bsg, but it involves utility/drivers/fw and takes time.

Please do not take my lack of responses during this time as ignoring
you. Will update the thread when we have a conclusion.


> Thanks,
> 
> Bart.
> 
> 

