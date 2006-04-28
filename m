From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: request to add aic94xx to -mm
Date: Fri, 28 Apr 2006 12:31:29 -0500
Message-ID: <1146245489.5251.42.camel@mulgrave.il.steeleye.com>
References: <1146243246.5251.29.camel@mulgrave.il.steeleye.com>
	 <44524DF6.3000509@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:18102 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751429AbWD1Rbr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 13:31:47 -0400
In-Reply-To: <44524DF6.3000509@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2006-04-28 at 13:16 -0400, Douglas Gilbert wrote:
> James Bottomley wrote:
> > Hi Andrew,
> > 
> > I'd like to see aic94xx added to -mm to get it wider exposure subject to
> > the following caveats:
> > 
> > 1. Hotplug is still a bit of a mess
> > 2. SATA attachment doesn't work
> 
> 3. my whole SCSI subsystem locked up a couple of times.

Well, no, the above is supposed to be the list of things I'm not
interested in bug reports on unless accompanied by code fixes.  If it
locks up the scsi subsystem I am interested in that ... I do run two of
these machines as SCSI test/build machines with no problems like
this ... do you have a bug report?

James


