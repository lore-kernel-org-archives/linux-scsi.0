From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [0/2]
Date: 12 May 2003 15:53:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052772814.3600.1.camel@mulgrave>
References: <20030509063321.GA3259@beaverton.ibm.com>
	<1052711864.1768.7.camel@mulgrave>
	<20030512063833.GA4133@beaverton.ibm.com>
	<1052761851.2093.55.camel@mulgrave> <1052762365.2148.59.camel@mulgrave>
	<20030512184140.GB3226@beaverton.ibm.com>
	<1052770234.1769.75.camel@mulgrave>
	<20030512203507.GC3226@beaverton.ibm.com>
	<1052772136.1769.103.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:35589 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262642AbTELUk4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 16:40:56 -0400
In-Reply-To: <1052772136.1769.103.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, mochel@osdl.org

On Mon, 2003-05-12 at 15:42, James Bottomley wrote:
> On Mon, 2003-05-12 at 15:35, Mike Anderson wrote:
> > I checked out that setting kobj.ktype also seems to solve the problem
> > (using a hacked version of scsi_debug and calling scsi_register followed
> > by a call to scsi_unregister). This would give a more localized work
> > around, but device_initialize kobj_set_kset_s may be a better choice.
> 
> Yes, that might fix it, setting the kset would cause a spurious
> kset_put. I'll try it out.
> 
> > What slab size? (size-512)
> 
> size-4096

well, just setting the kset still gives me my check_poison_obj use after
free.  I'll see if I can find it.

James


