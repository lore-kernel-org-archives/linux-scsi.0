From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 3 Mar 2006 09:03:56 -0800
Message-ID: <20060303170356.GA31136@us.ibm.com>
References: <20060303101420.78398.qmail@web31806.mail.mud.yahoo.com> <1141399404.3928.5.camel@mulgrave.il.steeleye.com> <440867B7.70703@s5r6.in-berlin.de> <1141403188.3928.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:26064 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1030244AbWCCRET (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2006 12:04:19 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k23H4CX1015609
	for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2006 12:04:12 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k23H4Cxv124214
	for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2006 12:04:12 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k23H4Boh012940
	for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2006 12:04:11 -0500
Content-Disposition: inline
In-Reply-To: <1141403188.3928.16.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, ltuikov@yahoo.com, "Tarte, Robert" <Robert_Tarte@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Fri, 2006-03-03 at 16:58 +0100, Stefan Richter wrote:
> > James Bottomley wrote:
> > > Assuming the cages are all powered up, which is beyond
> > > the driver control, then serialising the scan will allow one to
> > > specify /dev/sda1 deterministically for root.
> > 
> > Does SAS provide a persistent globally unique property of a device, or
> > has SAS to rely on bus topology to uniqely identify devices?
> 
> Yes ... naturally; all modern SCSI devices provide a variety of ways of
> identifying them. In the fullness of time, I expect udev and initramfs
> to support all of these, allowing the user free range of specifications.
> I also expect the boot system to provide a timeout (or wait forever)
> parameter for delaying before these become visible.  However, none of
> these problems are kernel issues.

Well this may not be kernel issue, the perception to many users is that
something is wrong with the IO subsystem.  I would agree we know how to
solve this, but I have need seen any distro based mkinitrd scripts
generate an initrd with a "wait for root dev" step. 

Does anyone know of a distro initrd / initramfs creation script that has
this support? As a side note I do not understand historically why one
would every want to leave the initrd without a root dev present and end in
an oops.

-andmike
--
Michael Anderson
andmike@us.ibm.com
