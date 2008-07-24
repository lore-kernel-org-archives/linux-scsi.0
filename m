From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Thu, 24 Jul 2008 22:44:03 +0900
Message-ID: <20080724224438B.fujita.tomonori@lab.ntt.co.jp>
References: <20080722175729.GC8833@beardog.cca.cpqcorp.net>
	<20080724101953R.fujita.tomonori@lab.ntt.co.jp>
	<20080724133012.GH8833@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:57496 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbYGXNsr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2008 09:48:47 -0400
In-Reply-To: <20080724133012.GH8833@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mike.miller@hp.com

On Thu, 24 Jul 2008 08:30:12 -0500
scameron@beardog.cca.cpqcorp.net wrote:

> On Thu, Jul 24, 2008 at 10:32:45AM +0900, FUJITA Tomonori wrote:
> > CC'ed linux-scsi, why did you drop it?
> 
> You mean my SCSI cciss driver?  For a few reasons:

Ah, I just meant that you dropped linux-scsi mailing list in the
previous mail though I sent my first RFC mail to linux-kernel and
linux-scsi.


> With help from udev it is less disruptive, but I'm still unsure
> about how smoothly such a change will fit in with the installation 
> process of various distributions.

They need to make sure that udev cciss rules match with the kernel
configuration but I don't think it's difficult.


> As for the patches I mentioned which were previously ignored
> for improving how the current cciss SCSI code handled hot 
> plogging, if you're curious about that, check here:
> 
> http://marc.info/?l=linux-scsi&m=120213565000426&w=4
> 
> A change like that becomes more important if logical drives
> are exposed through the scsi layer.

We need to think about the best way to map (expose) logical and
physical drivers to SCSI luns. As I wrote before, I'm interested in
how HP SCSI driver does.
