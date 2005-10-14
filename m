From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Followup on patches as571 and as572
Date: Fri, 14 Oct 2005 11:01:56 -0500
Message-ID: <1129305716.4824.15.camel@mulgrave>
References: <Pine.LNX.4.44L0.0510141103380.5552-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:25999 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750774AbVJNQCI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 12:02:08 -0400
In-Reply-To: <Pine.LNX.4.44L0.0510141103380.5552-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2005-10-14 at 11:09 -0400, Alan Stern wrote:
> I haven't heard anything back about these two patches:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112801815229091&w=2
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112801965207763&w=2
> 
> They were submitted a couple of weeks ago, and they don't appear in your 
> scsi-misc git repository.

I was waiting for Jens to comment since he's supposed to be the sr
maintainer.

To me, the first looks fine.  The second alters the behaviour of error
completion.  Previously we report the number of good bytes up to the
first bad block in linux filesystem terms.  Now we report it up to the
first bad block in hardsect terms.  I'm not sure if anything actually
cares, but I don't really see a reason to change it.

James


