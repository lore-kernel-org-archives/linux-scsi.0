Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76574C2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EFAF22280
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgKCNqu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 08:46:50 -0500
Received: from netrider.rowland.org ([192.131.102.5]:38737 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1729249AbgKCNpY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 08:45:24 -0500
Received: (qmail 1521753 invoked by uid 1000); 3 Nov 2020 08:45:23 -0500
Date:   Tue, 3 Nov 2020 08:45:23 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Luo Jiaxing <luojiaxing@huawei.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, andriy.shevchenko@linux.intel.com,
        linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
        john.garry@huawei.com, himanshu.madhani@cavium.com,
        felipe.balbi@linux.intel.com, uma.shankar@intel.com,
        anshuman.gupta@intel.com, animesh.manna@intel.com,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH v3 0/5] Introduce a new helper marco
 DEFINE_SHOW_STORE_ATTRIBUTE at seq_file.c
Message-ID: <20201103134523.GA1521034@rowland.harvard.edu>
References: <1604406584-53926-1-git-send-email-luojiaxing@huawei.com>
 <20201103133644.GA2067567@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103133644.GA2067567@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 03, 2020 at 02:36:44PM +0100, Greg KH wrote:
> On Tue, Nov 03, 2020 at 08:29:39PM +0800, Luo Jiaxing wrote:
> > We already own DEFINE_SHOW_ATTRIBUTE() helper macro for defining attribute
> > for read-only file, but we found many of drivers also want a helper macro
> > for read-write file too.
> > 
> > So we add this macro to help decrease code duplication.
> > 
> > ---
> >  v1->v2:
> >         1.Rename DEFINE_STORE_ATTRIBUTE() to DEFINE_SHOW_STORE_ATTRIBUTE().
> >  v2->v3:
> >         1.Fixed some spelling mistakes in commit.
> >         2.Revised resumes are added for easy tracing.
> 
> You forgot to address Al Viro's review comments :(

You also might want to fix the type in the Subject line ("marco" instead 
of "macro").

Alan Stern
