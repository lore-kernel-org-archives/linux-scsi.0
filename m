From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: read only scsi disk
Date: Thu, 09 Feb 2006 14:41:12 -0500
Message-ID: <1139514073.9367.105.camel@localhost.localdomain>
References: <1139504647.9367.57.camel@localhost.localdomain>
	 <43EB99B3.3020206@s5r6.in-berlin.de>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orca.ele.uri.edu ([131.128.51.63]:59085 "EHLO orca.ele.uri.edu")
	by vger.kernel.org with ESMTP id S1750741AbWBITlj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2006 14:41:39 -0500
In-Reply-To: <43EB99B3.3020206@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Damian Pietras <daper@daper.net>

thx, i found this was changed in at least 2.6.16-rc2.

ming



On Thu, 2006-02-09 at 20:36 +0100, Stefan Richter wrote:
> Ming Zhang wrote:
> > from sd.c, it looks like removable is judged first.
> > 
> >              if (sdp->removable)
> >                    sd_read_write_protect_flag(sdkp, disk->disk_name,
> >                                                    buffer);
> 
> This has been changed in the meantime. Check the current sources.

