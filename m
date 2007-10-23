From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PATCH] final SCSI pieces for the merge window
Date: Tue, 23 Oct 2007 18:06:51 -0400
Message-ID: <471E707B.1020505@garzik.org>
References: <1193173128.3434.1.camel@localhost.localdomain>	 <471E6313.1040704@garzik.org> <1193174424.3434.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47532 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbXJWWG5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Oct 2007 18:06:57 -0400
In-Reply-To: <1193174424.3434.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> On Tue, 2007-10-23 at 17:09 -0400, Jeff Garzik wrote:
>> James Bottomley wrote:
>>> This should be the final SCSI updates; it's mainly just a few accessor
>>> completion updates and two driver merges (sym2 and qla2xxx) we also
>>> secured DaveM's agreement to remove fcal/fc4, which explains the high
>>> removal line count.
>>>
>>> The patch is available here:
>>>
>>> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
>> I guess I have the go-ahead to merge the end-CDROM-polling async 
>> notification work you've been repeatedly ignoring?
> 
> I haven't been ignoring it ... it just needs quite a bit of work; the
> best way to accelerate it seems to be simply to do it (add the
> supported/trigger event bitmasks and expand the infrastructure).  I just
> haven't had the time within the merge window.

James, things cannot get bottlenecked like this.  You have had MONTHS to 
say something like this.  The code was ready BEFORE the merge window.

I really think you have the knowledge to be SCSI maintainer, but not the 
time.

	Jeff



