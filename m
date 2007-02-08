From: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@lsi.com>
Subject: RE: chip 1000:0055 (LSI1068 PCI-X) Fusion-MPT/MegaRAID
Date: Thu, 8 Feb 2007 06:55:09 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C265014A8FF6@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48436 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbXBHNze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2007 08:55:34 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Cc: "Kolli, Neela" <Neela.Kolli@lsi.com>, "Patro, Sumant" <Sumant.Patro@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org

> 
> Hello Sreenivas,
> 
> > We have already been alerted (by OEMs among others) that the modinfo
on
> > megaswr driver needlessly shows "GPL" as the license. Ours is a
binary
> > only proprietary driver. I have since corrected the MODULE_LICENSE
label
> > to "LSI Proprietary" and updated the OEM versions. If this is not
> > reflected in their respective web-sites already, it should soon be.
> >
> > You must have an old version of this driver. We have changed the
name
> > from "megaswr" to "megasr".
> >
> > Thanks,
> > Sreenivas
> >
> 
> 
> Really no way to get sources or more information about the driver for
> LSI1068 chip with pciid 1000:0055 ?
> This should help people who are using RAID on such chip and want to
use
> a recent kernel...
> 

I haven't looked for it myself, but what you say sounds fair. You should
be able to get the information from the vendor(s) that you downloaded
the
driver package from. Would you please point me to all or any links that 
you are aware of?

> Here's the modinfo for a recent 'megasr', from a well known
> hardware/processor manufacturer
> ========================================================
> [root@iotiger2 x86_64]# modinfo megasr.ko
> filename:       megasr.ko
> parm:           dbglvl_g:driver-wide debug flag
> license:        GPL
> description:    LSI Logic Software RAID5 Driver
> author:         LSI Logic Corporation
> ...

Even this is an old driver. The string still says "GPL". I guess it
takes
time for drivers to pass vendors' long validation period.

> 
> Hope that this mail will also help people who are looking for linux
> hardware support about LSI 1068 1000:0055 chip.
> 

I hope so too.

Thanks,
Sreenivas
