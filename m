From: Thomas Beutin <tyrone@laokoon.IN-Berlin.DE>
Subject: Re: AIC7902 lockups on Intel SMP (Re: HD somtimes hanging)
Date: Thu, 24 Jul 2003 21:38:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030724213847.B31870@laokoon.bug.net>
References: <20030724151233.E9280@laokoon.bug.net> <1059057411.6798.30.camel@carwash.duncangibb.com> <1382692704.1059068823@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hirsch.in-berlin.de ([192.109.42.6]:19934 "EHLO
	hirsch.in-berlin.de") by vger.kernel.org with ESMTP id S268019AbTGXTaB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2003 15:30:01 -0400
Received: from hirsch.in-berlin.de (localhost [127.0.0.1])
	by hirsch.in-berlin.de (8.12.9/8.12.9/Debian-1) with ESMTP id h6OJj8OF011284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2003 21:45:08 +0200
Received: (from uucp@localhost)
	by hirsch.in-berlin.de (8.12.9/8.12.9/Debian-1) with UUCP id h6OJj8st011275
	for linux-scsi@vger.kernel.org; Thu, 24 Jul 2003 21:45:08 +0200
Received: (from tyrone@localhost)
	by laokoon.bug.net (8.9.3/8.9.3) id VAA00494
	for linux-scsi@vger.kernel.org; Thu, 24 Jul 2003 21:38:47 +0200
Content-Disposition: inline
In-Reply-To: <1382692704.1059068823@aslan.btc.adaptec.com>; from gibbs@scsiguy.com on Thu, Jul 24, 2003 at 11:47:04AM -0600
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thu, Jul 24, 2003 at 11:47:04AM -0600, Justin T. Gibbs wrote:
> It looks like you have a very flakey bus.  The BSY line is probably
> glitching.  In the trace you provided, we successfully selected the
> device at ID 3 and are waiting for the target to take us to the first
> phase.  The REQ for that phase never occurs and in fact the BSY line
> is not always driven.  Very, very weird.  The target controls both
> the REQ and BSY lines, so this is either a problem with the target,
> your cabling, or your termination.

I will give my system a try next time when i have access to the
machine.
Although i cannot believe that: all disks are mounted in a plug-in
for the backplane (SCA HSBP M15), and the first disk works fine
all the times.
Maybe i change the drives in the plug-ins and the position of the
drives (but i cannot use all positions because i have to place the
IBM disk at the first position).

-tb
-- 
Thomas Beutin                             tb@laokoon.IN-Berlin.DE
Beam me up, Scotty. There is no intelligent live down in Redmond.
