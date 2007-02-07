From: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@lsi.com>
Subject: RE: chip 1000:0055 (LSI1068 PCI-X) Fusion-MPT/MegaRAID
Date: Wed, 7 Feb 2007 10:34:05 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C265014A8E8B@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53310 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965541AbXBGReN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 12:34:13 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>, "Kolli, Neela" <Neela.Kolli@lsi.com>"Kolli, Neela" <Neela.Kolli@lsi.com>, "Patro, Sumant" <Sumant.Patro@lsi.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org

Hello Fred,

> 
> There's a LSI 1068 chip that can be found on NEC hardware (also
> Intel/Supermicro/Hitachi, ...) and that can provide RAID 0 and 1 based
> on a MegaRAID BIOS.
> 

Hmm, no. This is not MegaRAID BIOS.

> 
> - LSI1068 'MegaRAID':
> pciid 1000:0055
> embedded MegaRAID BIOS, providing RAID 0 and 1
> 
> 
> But in this last mode, there's no way to use this chip with megaraid
> driver from kernel.org
> (so no way to use RAID device created by MegaRAID BIOS)
> 

The kernel.org megaraid driver controls our flagship HW RAID
controllers.
1000:0055 is not one of them.

> => There's a driver provided by several vendors (Intel, Supermicro,
...)
> for RHEL and SLES, and that can be found on the web.
> This driver is named 'megaswr' (aka 'megasr', MegaRAID software RAID
> driver):
> ==========================================================
> > [root@iotiger2 x86_64]# modinfo megaswr.ko
> > filename:       megaswr.ko
> > parm:           low_mem_g:Set to 1 to simulate low mem condition
> > parm:           dbglvl_g:driver-wide debug flag
> > license:        GPL
> > description:    LSI Logic SofrRAID Driver
> > author:         LSI Logic Corporation
> > alias:          pci:v00000000d00000000sv00000000sd00000000bc*sc*i*
> > alias:          pci:v00000000d00000000sv00000000sd00000000bc*sc*i*
> > alias:          pci:v00000000d00000000sv00000000sd00000000bc*sc*i*
> > ...
> > alias:          pci:v00000000d00000000sv00000000sd00000000bc*sc*i*
> > alias:          pci:v00000000d00000000sv00000000sd00000000bc*sc*i*
> > depends:        scsi_mod
> > vermagic:       2.6.9-22.ELsmp SMP gcc-3.4
> ==========================================================
> Do you have any information about this driver ?
> Seems that it is provided under GPL license.
> Who can provide the sources for this module ?
> (only binary are provided)
> 

We have already been alerted (by OEMs among others) that the modinfo on
megaswr driver needlessly shows "GPL" as the license. Ours is a binary
only proprietary driver. I have since corrected the MODULE_LICENSE label
to "LSI Proprietary" and updated the OEM versions. If this is not
reflected in their respective web-sites already, it should soon be.

You must have an old version of this driver. We have changed the name
from "megaswr" to "megasr".

Thanks,
Sreenivas
