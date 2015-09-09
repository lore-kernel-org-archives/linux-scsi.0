From: Huang Rui <ray.huang@amd.com>
Subject: Re: [PATCH]SCSI:Refine the way to fix NULL pointer dereference in
 runtime PM
Date: Wed, 9 Sep 2015 17:33:45 +0800
Message-ID: <20150909093344.GA9459@hr-slim.amd.com>
References: <1441782131.5845.73.camel@kxue-X58A-UD3R>
 <20150909083058.GA6425@hr-slim.amd.com>
 <1441788007.5845.77.camel@kxue-X58A-UD3R>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0055.outbound.protection.outlook.com ([207.46.100.55]:60048
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754879AbbIIJdf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Sep 2015 05:33:35 -0400
Content-Disposition: inline
In-Reply-To: <1441788007.5845.77.camel@kxue-X58A-UD3R>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ken Xue <Ken.Xue@amd.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: "Huang, Shane" <Shane.Huang@amd.com>, "Yu, Xiangliang" <Xiangliang.Yu@amd.com>, "aaron.lu@intel.com" <aaron.lu@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@Odin.com" <JBottomley@Odin.com>, SPG_Linux_Kernel <SPG_Linux_Kernel@amd.com>

On Wed, Sep 09, 2015 at 04:40:07PM +0800, Ken Xue wrote:
> On Wed, 2015-09-09 at 16:30 +0800, Huang Rui wrote:
> > On Wed, Sep 09, 2015 at 03:02:11PM +0800, Ken Xue wrote:
> > > From 844ebfcecad7ddaf7206e0474c600b0146b4ef21 Mon Sep 17 00:00:00 2001
> > > From: Ken Xue <Ken.Xue@amd.com>
> > > Date: Wed, 9 Sep 2015 14:55:21 +0800
> > > Subject: [PATCH] SCSI:Refine the way to fix NULL pointer dereference in
> > >  runtime PM
> > > 
> > > There was a patch about Bugzilla #101371.
> > 
> > Which Bugzilla? I guess you should put a link or oops message of NULL
> > pointer dereference here. Then other guys can know detail infomation
> > of this fix.
> > 
> You can find out previous patch with commit ID 49718f.
> You also can find log with below link
> https://bugzilla.kernel.org/show_bug.cgi?id=101371
> 

I see. So maybe we would better mark the commit ID. :)

Alan, could you please take a look?

Thanks,
Rui
