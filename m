Return-Path: <SRS0=jGTy=33=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BECF9C352A2
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 09:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 873BE20726
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 09:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgBGJIO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Feb 2020 04:08:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:59954 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbgBGJIO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Feb 2020 04:08:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 78A67B216;
        Fri,  7 Feb 2020 09:08:12 +0000 (UTC)
Message-ID: <44e8e2cad35ea91f4b4a8fceb2e12930c62760b1.camel@suse.com>
Subject: Re: [PATCH 0/4] qla2xxx patches for kernel v5.6
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>
Cc:     linux-scsi@vger.kernel.org, "dwagner@suse.de" <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Date:   Fri, 07 Feb 2020 10:09:39 +0100
In-Reply-To: <4478372c-7e34-c35f-6ccc-dff1422b6256@acm.org>
References: <20191209180223.194959-1-bvanassche@acm.org>
         <bb273446a0f294e37dc0afb2c450fb761e345260.camel@suse.com>
         <559ee60f-43e8-b228-f14b-7453d62e7780@acm.org>
         <cb2ad8b48a412ad164ebbe809bc80b238b16a0b4.camel@suse.com>
         <4478372c-7e34-c35f-6ccc-dff1422b6256@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bart,

On Thu, 2020-02-06 at 13:01 -0800, Bart Van Assche wrote:
> On 2/6/20 12:52 PM, Martin Wilck wrote:
> > On Thu, 2020-02-06 at 12:49 -0800, Bart Van Assche wrote:
> > > The first patch of this series has been queued by Martin Petersen
> > > for
> > > the v5.7 merge window. I plan to repost patches 2/4 and 4/4 of
> > > this
> > > series after the merge window has closed. Patch 3/4 (the fix for
> > > point-to-point mode) has been dropped because I'm not confident
> > > that
> > > my
> > > fix is a proper fix.
> > 
> > Well, Himanshu had ack'd it, and Roman too IIRC ... have you given
> > up
> > on the subject?
> 
> That patch is not sufficient to make point-to-point mode work
> reliably 
> on 8 Gb/s adapters, the adapter type on which I noticed that 
> point-to-point mode is broken. If anyone else wants to fix 
> point-to-point mode on older adapters that would be welcome.

Sorry for insisting - in your original submission "Revert "qla2xxx: Fix
Nport ID display value" from 11/09/2019, you'd identified this as a
regression caused by 0aabb6b699f7 ("scsi: qla2xxx: Fix Nport ID display
value"). Are you saying that that wasn't the whole truth? Had N2N been
broken before already? Did N2N with "old" adapters ever work with
previous versions of the driver? Which ones?

@Himanshu, Quinn, can you say anything about this subject? Do you
intend to work on fixing this any time soon?

Martin


