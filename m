From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Fri, 22 Aug 2003 08:55:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030822085512.A29419@beaverton.ibm.com>
References: <1061299572.3f4225742287c@impt1-2.free.fr> <20030819182347.O8420@sistina.com> <20030820012204.449c2b34.christophe.varoqui@free.fr> <20030820150253.X8420@sistina.com> <1061389164.3f43836ccaf56@impt1-1.free.fr> <20030821144716.Y8420@sistina.com> <1061483692.3f44f4ac24e07@impt1-2.free.fr> <20030822105146.B8420@sistina.com> <20030822075953.A28851@beaverton.ibm.com> <1061566443.3f4637ebcd1ca@impt1-2.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:33946 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S263268AbTHVPzz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2003 11:55:55 -0400
Content-Disposition: inline
In-Reply-To: <1061566443.3f4637ebcd1ca@impt1-2.free.fr>; from christophe.varoqui@free.fr on Fri, Aug 22, 2003 at 05:34:03PM +0200
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@free.fr
Cc: mauelshagen@sistina.com, linux-scsi@vger.kernel.org

On Fri, Aug 22, 2003 at 05:34:03PM +0200, christophe.varoqui@free.fr wrote:
> Selon Patrick Mansfield <patmans@us.ibm.com>:
> > The sending of any special command to enable an alternative path (like the
> > ghost LUN) should be done in a kernel thread or some way that allows the
> > root file system to be multi-pathed on such devices.
> > 
> Early userspace should do the trick to keep vendors out of kernel development.
> Anyway, it is still not clear to me how HBAs BIOS treat such ghost LUNs at boot.

I don't mean boot time, but special commands sent at the time of failure.

You can't run a user space program if the disk it's on needs to failover.

-- Patrick Mansfield
