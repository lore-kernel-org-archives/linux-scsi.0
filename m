From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] REPORT LUN scan even if no storage is available on LUN 0
Date: Fri, 14 Jan 2005 08:28:15 -0800
Message-ID: <20050114162815.GA32162@us.ibm.com>
References: <20041210123333.GD685@bogon.ms20.nix> <20041213222206.GA18893@us.ibm.com> <20050110164200.GA8655@bogon.ms20.nix> <20050111181500.GA9046@us.ibm.com> <20050113124032.GB5701@bogon.ms20.nix> <20050114000115.GA13676@us.ibm.com> <20050114093200.GB5724@bogon.ms20.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:5031 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262019AbVANQ2z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2005 11:28:55 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j0EGStRK024711
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jan 2005 11:28:55 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0EGSt8u235912
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jan 2005 11:28:55 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j0EGStQb026896
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jan 2005 11:28:55 -0500
Content-Disposition: inline
In-Reply-To: <20050114093200.GB5724@bogon.ms20.nix>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guido Guenther <agx@sigxcpu.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jan 14, 2005 at 10:32:00AM +0100, Guido Guenther wrote:
> On Thu, Jan 13, 2005 at 04:01:15PM -0800, Patrick Mansfield wrote:
> > On Thu, Jan 13, 2005 at 01:40:32PM +0100, Guido Guenther wrote:
> > 
> > > > Can you turn on some scsi logging, and send that?
> > > Sure. I tried scsi_logging_level=... on the kernel command line but it
> > > didn't show anything, did I miss something obvious?
> > > /proc/sys/dev/scsi/logging_level was still zero afterwards.
> > 
> > It is a sysctl variable, so you can set it after you are booted, per my
> > other email (and still below), and man sysctl.
> Yes I saw that, I was just wondering why scsi_logging_level doesn't work
> also it's a module option in scsi.c.

In-kernel module params have to be prefixed by the module name, like:

	scsi_mod.scsi_logging_level=0x2400

AFAIR if the param name is unknown, the kernel outputs a warning.

Note that most (all?) of the other scsi params have the "scsi_" removed,
though the variable name does not, like max_scsi_luns is set via max_luns.

-- Patrick Mansfield
