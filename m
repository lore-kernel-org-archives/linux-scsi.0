From: Willem Riede <wrlk@riede.org>
Subject: Re: devices with more than one node
Date: Tue, 13 Jan 2004 22:08:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040114030847.GG4339@linnie.riede.org>
References: <20040113193842.GA29887@suse.de> <20040113194631.GA3818@kroah.com> <20040113211122.GA28100@suse.de> <20040113212058.GA2595@kroah.com> <20040113150147.A9902@beaverton.ibm.com> <20040113231813.GA7409@kroah.com> <1074042776.4004979822819@wwws.torque.net>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc11.comcast.net ([204.127.202.55]:20978 "EHLO
	sccrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S266149AbUANDIs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2004 22:08:48 -0500
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.12.10/8.12.10) with ESMTP id i0E38lEM019190
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2004 22:08:47 -0500
Content-Disposition: inline
In-Reply-To: <1074042776.4004979822819@wwws.torque.net> (from dougg@torque.net on Tue, Jan 13, 2004 at 20:12:56 -0500)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2004.01.13 20:12, dougg@torque.net wrote:
> Quoting Greg KH <greg@kroah.com>:
> 
> > For scsi generic you should create a scsi generic class (scsi_generic?)
> > and create the individual sg devices in that directory (feel free to use
> > the simple_class.c code that is currently in the -mm tree if you want,
> > it makes it much simpler)
> 
> Does any device use the simple_class.c code yet?

I did in osst, see 
http://marc.theaimsgroup.com/?l=linux-kernel&m=107275923222124&w=2
  
> > > st also needs changes.
> 
> and osst.

Right. So I'm following this thread for guidance.

Regards, Willem Riede.
