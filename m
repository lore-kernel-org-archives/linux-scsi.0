From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: AIC7902 lockups on Intel SMP (Re: HD somtimes hanging)
Date: Thu, 24 Jul 2003 15:58:26 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1469742704.1059083906@aslan.btc.adaptec.com>
References: <20030724151233.E9280@laokoon.bug.net> <1059057411.6798.30.camel@carwash.duncangibb.com> <20030724174451.B14635@laokoon.bug.net>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:21974 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S271697AbTGXVlj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2003 17:41:39 -0400
In-Reply-To: <20030724174451.B14635@laokoon.bug.net>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Thomas Beutin <tyrone@laokoon.IN-Berlin.DE>, Duncan Gibb <duncangibb@uk.dmgworldmedia.com>
Cc: linux-scsi@vger.kernel.org

> (Especially the current transfer rate on Channel A Target 1 is
> somewhat less than expected.)
> 
> Maybe there is a new driver by Justin Gibbs, but i didn't found
> anything for the 2.4.21 kernel in
> http://people.freebsd.org/~gibbs/linux/SRC/

The 2.4 archive should work on just about any 2.4.X kernel.
I would highly recoment upgrading from 1.3.0.

I'm still not clear on what your problem is.  Can you provide
a full dmesg from the system and any diagnostic messages the
driver generates?

--
Justin

