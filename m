From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Subject: Re: chip 1000:0055 (LSI1068 PCI-X) Fusion-MPT/MegaRAID
Date: Thu, 08 Feb 2007 10:48:00 +0100
Message-ID: <45CAF1D0.7000109@ext.bull.net>
References: <9738BCBE884FDB42801FAD8A7769C265014A8E8B@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43855 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423176AbXBHJsB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2007 04:48:01 -0500
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C265014A8E8B@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@lsi.com>
Cc: "Kolli, Neela" <Neela.Kolli@lsi.com>, "Patro, Sumant" <Sumant.Patro@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org

Hello Sreenivas,

> We have already been alerted (by OEMs among others) that the modinfo on
> megaswr driver needlessly shows "GPL" as the license. Ours is a binary
> only proprietary driver. I have since corrected the MODULE_LICENSE label
> to "LSI Proprietary" and updated the OEM versions. If this is not
> reflected in their respective web-sites already, it should soon be.
> 
> You must have an old version of this driver. We have changed the name
> from "megaswr" to "megasr".
> 
> Thanks,
> Sreenivas
> 


Really no way to get sources or more information about the driver for
LSI1068 chip with pciid 1000:0055 ?
This should help people who are using RAID on such chip and want to use
a recent kernel...

Here's the modinfo for a recent 'megasr', from a well known
hardware/processor manufacturer
========================================================
[root@iotiger2 x86_64]# modinfo megasr.ko
filename:       megasr.ko
parm:           dbglvl_g:driver-wide debug flag
license:        GPL
description:    LSI Logic Software RAID5 Driver
author:         LSI Logic Corporation
...
alias:          pci:v00001000d00000055sv0000144Dsd0000D001bc*sc*i*
alias:          pci:v00001000d00000055sv000017AAsd00006B64bc*sc*i*
alias:          pci:v00001000d00000055sv0000107Bsd00009570bc*sc*i*
alias:          pci:v00001000d00000055sv0000107Bsd00009565bc*sc*i*
alias:          pci:v00001000d00000055sv00001170sd00000023bc*sc*i*
alias:          pci:v00001000d00000055sv00001033sd00008342bc*sc*i*
alias:          pci:v00001000d00000055sv00001033sd00008338bc*sc*i*
alias:          pci:v00001000d00000055sv00001033sd00008337bc*sc*i*
alias:          pci:v00001000d00000055sv00001033sd00008336bc*sc*i*
alias:          pci:v00001000d00000055sv00008086sd00003504bc*sc*i*
alias:          pci:v00001000d00000055sv00008086sd00003501bc*sc*i*
alias:          pci:v00001000d00000055sv00008086sd00003500bc*sc*i*
alias:          pci:v00001000d00000055sv00008086sd0000346Dbc*sc*i*
alias:          pci:v00001000d00000055sv00008086sd0000346Cbc*sc*i*
alias:          pci:v00001000d00000055sv00001000sd00003005bc*sc*i*
alias:          pci:v00001000d00000055sv00001000sd00001000bc*sc*i*
...
depends:        scsi_mod
vermagic:       2.6.9-42.EL gcc-3.4
========================================================

Hope that this mail will also help people who are looking for linux
hardware support about LSI 1068 1000:0055 chip.

regards
--
Frederic
