From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH]SCSI:Refine the way to fix NULL pointer dereference in
 runtime PM
Date: Wed, 9 Sep 2015 11:41:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1509091132520.2045-100000@iolanthe.rowland.org>
References: <20150909093344.GA9459@hr-slim.amd.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55663 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751390AbbIIPlE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2015 11:41:04 -0400
In-Reply-To: <20150909093344.GA9459@hr-slim.amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Huang Rui <ray.huang@amd.com>
Cc: Ken Xue <Ken.Xue@amd.com>, "Huang, Shane" <Shane.Huang@amd.com>, "Yu, Xiangliang" <Xiangliang.Yu@amd.com>, "aaron.lu@intel.com" <aaron.lu@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@Odin.com" <JBottomley@Odin.com>, SPG_Linux_Kernel <SPG_Linux_Kernel@amd.com>

On Wed, 9 Sep 2015, Huang Rui wrote:

> On Wed, Sep 09, 2015 at 04:40:07PM +0800, Ken Xue wrote:
> > On Wed, 2015-09-09 at 16:30 +0800, Huang Rui wrote:
> > > On Wed, Sep 09, 2015 at 03:02:11PM +0800, Ken Xue wrote:
> > > > From 844ebfcecad7ddaf7206e0474c600b0146b4ef21 Mon Sep 17 00:00:00 2001
> > > > From: Ken Xue <Ken.Xue@amd.com>
> > > > Date: Wed, 9 Sep 2015 14:55:21 +0800
> > > > Subject: [PATCH] SCSI:Refine the way to fix NULL pointer dereference in
> > > >  runtime PM
> > > > 
> > > > There was a patch about Bugzilla #101371.
> > > 
> > > Which Bugzilla? I guess you should put a link or oops message of NULL
> > > pointer dereference here. Then other guys can know detail infomation
> > > of this fix.
> > > 
> > You can find out previous patch with commit ID 49718f.
> > You also can find log with below link
> > https://bugzilla.kernel.org/show_bug.cgi?id=101371
> > 
> 
> I see. So maybe we would better mark the commit ID. :)
> 
> Alan, could you please take a look?

Yes.

Ken, your fix was good but the description was bad.  The description 
did not explain what the problem was or how you were going to fix it.

In fact, this change should be split up into two patches.  The first 
patch should simply revert commit 49718f0fb8c9 ("SCSI: Fix NULL pointer 
dereference in runtime PM") and the description should explain why that 
commit didn't work properly for the sr driver.

The second patch should make the new changes to the block core.  The 
description should explain why the changes are needed, and it can 
reference Bugzilla #101371.

Both patches should be tagged for the -stable kernels.  When you have 
done all that, you can add:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

to both patches.

Alan Stern

