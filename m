From: Douglas Gilbert <dougg@torque.net>
Subject: Re: request to add aic94xx to -mm
Date: Fri, 28 Apr 2006 13:16:38 -0400
Message-ID: <44524DF6.3000509@torque.net>
References: <1146243246.5251.29.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:2197 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030456AbWD1RQo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 13:16:44 -0400
In-Reply-To: <1146243246.5251.29.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> Hi Andrew,
> 
> I'd like to see aic94xx added to -mm to get it wider exposure subject to
> the following caveats:
> 
> 1. Hotplug is still a bit of a mess
> 2. SATA attachment doesn't work

3. my whole SCSI subsystem locked up a couple of times.

If that is still a problem then I would recommend other
testers place their root file system on a PATA disk :-)

> Could you send any bugs found back to linux-scsi (not the kernel
> bugzilla)?
> 
> The tree is at
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/aic94xx-sas-2.6.git
> 
> It's pretty much a working tree (as in most of the patches don't have
> proper commit logs), so I'm going to flatten it once we get agreement
> that it should go forwards into scsi-misc.

Doug Gilbert
