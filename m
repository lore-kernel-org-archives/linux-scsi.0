From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 0/5] mpt fusion: Add logging support
Date: Thu, 26 Jul 2007 10:37:48 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D708B3A74@NAMAIL4.ad.lsil.com>
References: <20070724100659.GA1831@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:37287 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934587AbXGZQhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 12:37:53 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070724100659.GA1831@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Tuesday, July 24, 2007 4:07 AM,  Prakash, Sathya wrote:

> The patches in this patch set adds support for logging 
> facility that can be used
> to debug a number of Fusion MPT related problems.
> 
> The logging support can be enabled or disabled changing the kernel
> configuration flag CONFIF_FUSION_LOGGING
> 
> The debug level can be programmed on the fly via SysFS (hex values)
> 	echo [level] > /sys/class/scsi_host/host#/debug_level
> and also can be passed as module parameter mpt_debug_level 
> for mptbase.ko
> 
> There are various debug levels that can be found in the 
> source file mptdebug.h
> 
> Since the difference is of size 175 KB, it is split into five 
> different patches
> grouped based on the files as described below.
> 
> 	[PATCH 1/5] : Changes for logging support in Kconfig, Makefile,
> 			 mptbase.h and addition of mptdebug.h
>  	[PATCH 2/5] : Changes in mptbase.c for logging support
>  	[PATCH 3/5] : Changes in mptscsih.c for logging support
>  	[PATCH 4/5] : Changes in mptfc.c mptlan.c mptsas.c and mptspi.c
> 		      for logging support
>  	[PATCH 5/5] : Changes in mptctl.c for logging support
> 


These set of patchs are to replace the current cumbersome implementation
of enabling debug defines in the driver Makefile, and recompiling the
driver.    The new method allows the enduser to enable/disable debug
information any time without having to recompile or reboot the system.
These code has been verified in the LSI test labs for several months,
and there is no performance regressions with this.  If there are no
other further objections, please apply.

ACK

Eric Moore     
