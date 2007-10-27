From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: single unused scsi-related CONFIG variable
Date: Fri, 26 Oct 2007 21:32:44 -0700
Message-ID: <20071026213244.9016bc2b.rdunlap@xenotime.net>
References: <Pine.LNX.4.64.0710261417230.2937@localhost.localdomain>
	<20071026212105.c74d2f6b.rdunlap@xenotime.net>
	<Pine.LNX.4.64.0710270022150.30030@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:44364 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750894AbXJ0Ecq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Oct 2007 00:32:46 -0400
Received: from midway.site ([71.117.233.180]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 21:32:44 -0700
In-Reply-To: <Pine.LNX.4.64.0710270022150.30030@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-scsi@vger.kernel.org

On Sat, 27 Oct 2007 00:28:03 -0400 (EDT) Robert P. J. Day wrote:

> On Fri, 26 Oct 2007, Randy Dunlap wrote:
> 
> > On Fri, 26 Oct 2007 14:18:05 -0400 (EDT) Robert P. J. Day wrote:
> >
> > >
> > > drivers/scsi/Kconfig:1322:config SCSI_QLOGIC_FC_FIRMWARE
> >
> > config SCSI_QLOGIC_FC_FIRMWARE
> > 	bool "Include loadable firmware in driver"
> > 	depends on SCSI_QLOGIC_FC
> >
> >
> > I don't find SCSI_QLOGIC_FC defined anywhere...
> 
> i'm just *guessing* that some SCSI_QLOGIC_FC-related logic existed
> once upon a time, it was removed, but the controlling Kconfig entry
> was overlooked.
> 
> so it would seem safe to just blast that single config entry above,
> no?  i can whip up a patch for that shortly.

Agreed.  Go for it.

---
~Randy
