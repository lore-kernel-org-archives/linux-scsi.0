From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Fri, 22 Aug 2003 07:59:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030822075953.A28851@beaverton.ibm.com>
References: <1061290087.3f4200678f811@impt2-2.free.fr> <20030819143552.K8420@sistina.com> <1061299572.3f4225742287c@impt1-2.free.fr> <20030819182347.O8420@sistina.com> <20030820012204.449c2b34.christophe.varoqui@free.fr> <20030820150253.X8420@sistina.com> <1061389164.3f43836ccaf56@impt1-1.free.fr> <20030821144716.Y8420@sistina.com> <1061483692.3f44f4ac24e07@impt1-2.free.fr> <20030822105146.B8420@sistina.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:55443 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263284AbTHVPAl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2003 11:00:41 -0400
Content-Disposition: inline
In-Reply-To: <20030822105146.B8420@sistina.com>; from Heinz.Mauelshagen@t-online.de on Fri, Aug 22, 2003 at 10:51:46AM +0200
List-Id: linux-scsi@vger.kernel.org
To: mauelshagen@sistina.com
Cc: christophe.varoqui@free.fr, linux-scsi@vger.kernel.org

On Fri, Aug 22, 2003 at 10:51:46AM +0200, Heinz J . Mauelshagen wrote:
> On Thu, Aug 21, 2003 at 06:34:52PM +0200, christophe.varoqui@free.fr wrote:

> > 2) multipath support for "bizarre" arrays need a userspace callback on path failure.
> > Agreement seems to be reached. Still not clear what provides this callback :
> > MD/DM or Block Layer ?
> 
> Presumably device-mapper multipath is the one we end up with at the
> end of the day, the answer is DM (the status information retrievable from
> DM provides it already)

The sending of any special command to enable an alternative path (like the
ghost LUN) should be done in a kernel thread or some way that allows the
root file system to be multi-pathed on such devices.

> Setting up a multipath mapping using dmsetup means creating a one line
> mapping table with a couple of parameters per path (see multipath target
> code we plan to release next week).

Is this the same code Joe is working on?

-- Patrick Mansfield
