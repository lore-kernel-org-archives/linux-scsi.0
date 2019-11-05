Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A807ACA9EC7
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 05:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 850A620869
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 05:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbfKEFZ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 00:25:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37918 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfKEFZ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 00:25:59 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iRrLm-0002LQ-63; Tue, 05 Nov 2019 05:25:54 +0000
Date:   Tue, 5 Nov 2019 05:25:54 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHES] drivers/scsi/sg.c uaccess cleanups/fixes
Message-ID: <20191105052554.GT26530@ZenIV.linux.org.uk>
References: <CAHk-=wgWRQo0m7TUCK4T_J-3Vqte+p-FWzvT3CB1jJHgX-KctA@mail.gmail.com>
 <20191011001104.GJ26530@ZenIV.linux.org.uk>
 <CAHk-=wgg3jzkk-jObm1FLVYGS8JCTiKppEnA00_QX7Wsm5ieLQ@mail.gmail.com>
 <20191013181333.GK26530@ZenIV.linux.org.uk>
 <CAHk-=wgrWGyACBM8N8KP7Pu_2VopuzM4A12yQz6Eo=X2Jpwzcw@mail.gmail.com>
 <20191013191050.GL26530@ZenIV.linux.org.uk>
 <CAHk-=wjJNE9hOKuatqh6SFf4nd65LG4ZR3gQSgg+rjSpVxe89w@mail.gmail.com>
 <20191016202540.GQ26530@ZenIV.linux.org.uk>
 <20191017193659.GA18702@ZenIV.linux.org.uk>
 <yq1muda53er.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1muda53er.fsf@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 04, 2019 at 11:54:20PM -0500, Martin K. Petersen wrote:
> 
> Hi Al!
> 
> > I've got a series that presumably fixes and cleans the things up
> > in that area; it didn't get any serious testing (the kernel builds
> > and boots, smartctl works as well as it used to, but that's not
> > worth much - all it says is that SG_IO doesn't fail terribly;
> > I don't have any test setup for really working with /dev/sg*).
> 
> I tested this last week without noticing any problems.
> 
> What's your plan for this series? Want me to queue it up for 5.5?

I can put it into vfs.git into a never-rebased branch or you could put it
into scsi tree - up to you...
