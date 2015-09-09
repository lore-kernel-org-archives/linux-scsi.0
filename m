From: Ken Xue <Ken.Xue@amd.com>
Subject: Re: [PATCH]SCSI:Refine the way to fix NULL pointer dereference in
 runtime PM
Date: Wed, 9 Sep 2015 16:40:07 +0800
Message-ID: <1441788007.5845.77.camel@kxue-X58A-UD3R>
References: <1441782131.5845.73.camel@kxue-X58A-UD3R>
	 <20150909083058.GA6425@hr-slim.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0074.outbound.protection.outlook.com ([157.56.111.74]:7578
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751837AbbIIIoL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Sep 2015 04:44:11 -0400
In-Reply-To: <20150909083058.GA6425@hr-slim.amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Huang Rui <ray.huang@amd.com>
Cc: stern@rowland.harvard.edu, Shane.Huang@amd.com, Xiangliang.Yu@amd.com, aaron.lu@intel.com, linux-scsi@vger.kernel.org, JBottomley@Odin.com, SPG_Linux_Kernel@amd.com

On Wed, 2015-09-09 at 16:30 +0800, Huang Rui wrote:
> On Wed, Sep 09, 2015 at 03:02:11PM +0800, Ken Xue wrote:
> > From 844ebfcecad7ddaf7206e0474c600b0146b4ef21 Mon Sep 17 00:00:00 2001
> > From: Ken Xue <Ken.Xue@amd.com>
> > Date: Wed, 9 Sep 2015 14:55:21 +0800
> > Subject: [PATCH] SCSI:Refine the way to fix NULL pointer dereference in
> >  runtime PM
> > 
> > There was a patch about Bugzilla #101371.
> 
> Which Bugzilla? I guess you should put a link or oops message of NULL
> pointer dereference here. Then other guys can know detail infomation
> of this fix.
> 
You can find out previous patch with commit ID 49718f.
You also can find log with below link
https://bugzilla.kernel.org/show_bug.cgi?id=101371



