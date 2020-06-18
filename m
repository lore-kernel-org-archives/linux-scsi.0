Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B51C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 08:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7849220706
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 08:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgFRIOK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 04:14:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:50626 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728391AbgFRIOJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jun 2020 04:14:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CC7EEAD3A;
        Thu, 18 Jun 2020 08:14:07 +0000 (UTC)
Date:   Thu, 18 Jun 2020 10:14:07 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/4] gdth: reindent and whitespace cleanup
Message-ID: <20200618081407.qsm4otp2w2bmcuil@beryllium.lan>
References: <20200616121821.99113-1-hare@suse.de>
 <20200616121821.99113-2-hare@suse.de>
 <20200617082145.mdsu56bclo3p3dg4@beryllium.lan>
 <2a7473b3-62af-f7d2-f73a-adcabe21701e@suse.de>
 <72827be0-a44a-0163-acb8-04ff3bde86ce@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72827be0-a44a-0163-acb8-04ff3bde86ce@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 17, 2020 at 10:48:10AM +0200, Hannes Reinecke wrote:
> On 6/17/20 10:34 AM, Hannes Reinecke wrote:
> > On 6/17/20 10:21 AM, Daniel Wagner wrote:
> > > On Tue, Jun 16, 2020 at 02:18:18PM +0200, Hannes Reinecke wrote:
> > > > Long overdue. No functional change.
> > > 
> > > Did you test if compiler generates the same output? I don't think anyone
> > > wants to review this patch :)
> > > 
> > Hmm. No. Lemme check what happens...
> > 
> Phew. Just checked, and the disassembly is indeed identical.

I am not really convienced it is a good idea to reformat the whole
driver at this point. Sure, checkpatch.pl & friends will be more
happy with new changes. Though, in 10 years there were only 44
changes and I don't think there will be a lot more in the coming
years. Just my thoughts.
