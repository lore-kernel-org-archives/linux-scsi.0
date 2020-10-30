Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0353C4741F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 14:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F25A2087E
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 14:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgJ3OHD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 10:07:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:40078 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgJ3OHC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Oct 2020 10:07:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B586BAAF1;
        Fri, 30 Oct 2020 14:07:00 +0000 (UTC)
Date:   Fri, 30 Oct 2020 15:06:59 +0100
From:   David Disseldorp <ddiss@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/5] scsi: target: COMPARE AND WRITE miscompare sense
Message-ID: <20201030150659.7262c619@suse.de>
In-Reply-To: <yq15z6s1n9n.fsf@ca-mkp.ca.oracle.com>
References: <20201026190646.8727-1-ddiss@suse.de>
        <yq1blgk1nfx.fsf@ca-mkp.ca.oracle.com>
        <yq15z6s1n9n.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 29 Oct 2020 22:06:00 -0400, Martin K. Petersen wrote:

> >> This patchset adds missing functionality to return the offset of
> >> non-matching read/compare data in the sense INFORMATION field on
> >> COMPARE AND WRITE miscompare.  
> >
> > Applied 2-5 to 5.11/scsi-staging, thanks!  
> 
> Dropped again, breaks IB.
> 

Hmm, I overlooked ib_isert in the bad_sector->sense_info rename, sorry.
I'll post a v3 when done with testing.

Cheers, David
