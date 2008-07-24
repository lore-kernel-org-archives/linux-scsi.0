From: scameron@beardog.cca.cpqcorp.net
Subject: Re: HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Thu, 24 Jul 2008 08:30:12 -0500
Message-ID: <20080724133012.GH8833@beardog.cca.cpqcorp.net>
References: <20080722175729.GC8833@beardog.cca.cpqcorp.net> <20080724101953R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:3774 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbYGXNaN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 09:30:13 -0400
Content-Disposition: inline
In-Reply-To: <20080724101953R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scameron@beardog.cca.cpqcorp.net, mike.miller@hp.com

On Thu, Jul 24, 2008 at 10:32:45AM +0900, FUJITA Tomonori wrote:
> CC'ed linux-scsi, why did you drop it?

You mean my SCSI cciss driver?  For a few reasons:

At the time, it was just kind of a learning exercise, and I
didn't see it as supplanting the existing driver.  I didn't know
enough about udev to know that a smooth transition process
was perhaps possible, and it seemed very disruptive.  And,
seeing as how I work for HP, it isn't exactly within my
authority to just decide by myself the course the driver
development should take.  Paradoxically, if a person works
for a company that has nothing to do with the driver, one
has more freedom to do whatever one wants with the code.

With help from udev it is less disruptive, but I'm still unsure
about how smoothly such a change will fit in with the installation 
process of various distributions.

I will see if management here will let me send you the patches 
from when I last looked at this, which was a little over a year ago.
(2.6.20 timeframe), not necessarily to use as is, but in case
maybe it helps to see how somebody else proceeded. 

As for the patches I mentioned which were previously ignored
for improving how the current cciss SCSI code handled hot 
plogging, if you're curious about that, check here:

http://marc.info/?l=linux-scsi&m=120213565000426&w=4

A change like that becomes more important if logical drives
are exposed through the scsi layer.

-- steve

