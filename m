From: christophe.varoqui@free.fr
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Fri, 22 Aug 2003 17:34:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061566443.3f4637ebcd1ca@impt1-2.free.fr>
References: <1061290087.3f4200678f811@impt2-2.free.fr> <20030819143552.K8420@sistina.com> <1061299572.3f4225742287c@impt1-2.free.fr> <20030819182347.O8420@sistina.com> <20030820012204.449c2b34.christophe.varoqui@free.fr> <20030820150253.X8420@sistina.com> <1061389164.3f43836ccaf56@impt1-1.free.fr> <20030821144716.Y8420@sistina.com> <1061483692.3f44f4ac24e07@impt1-2.free.fr> <20030822105146.B8420@sistina.com> <20030822075953.A28851@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-2.free.fr ([213.228.0.176]:16090 "EHLO
	postfix4-2.free.fr") by vger.kernel.org with ESMTP id S263515AbTHVPeJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2003 11:34:09 -0400
In-Reply-To: <20030822075953.A28851@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: mauelshagen@sistina.com, linux-scsi@vger.kernel.org

Selon Patrick Mansfield <patmans@us.ibm.com>:
> The sending of any special command to enable an alternative path (like the
> ghost LUN) should be done in a kernel thread or some way that allows the
> root file system to be multi-pathed on such devices.
> 
Early userspace should do the trick to keep vendors out of kernel development.
Anyway, it is still not clear to me how HBAs BIOS treat such ghost LUNs at boot.

