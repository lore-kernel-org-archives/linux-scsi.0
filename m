From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add help to WAIT_SCAN option
Date: Sat, 26 May 2007 14:50:14 -0500
Message-ID: <1180209014.3712.69.camel@mulgrave.il.steeleye.com>
References: <20070526191127.GB7080@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:48746 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759131AbXEZTuQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 May 2007 15:50:16 -0400
In-Reply-To: <20070526191127.GB7080@colo.lackof.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-scsi@vger.kernel.org, Thibaut VARENE <T-Bone@parisc-linux.org>

On Sat, 2007-05-26 at 13:11 -0600, Grant Grundler wrote:
> Thibaut Varene's parisc box didn't find the root disk.
> Problem is he had ASYNC_SCAN enabled and the required SYM2 driver builtin
> but the root disk wasn't discovered before the kernel wanted to mount root.
> Oh, and he (like many folks who build their own kernels) didn't use
> an initrd or initramfs. So no chance to load scsi_wait_scan module.
> 
> This patch enables one to select "y" for WAIT_SCAN option and adds
> help text on how/when to use "m" vs "y".

This solution is still as wrong as it was the last three times it was
submitted to linux-scsi:

http://marc.info/?t=117906989600001
http://marc.info/?t=117926627700012
http://marc.info/?t=117923062000004

A better, but still not quite right fix is here:

http://marc.info/?l=linux-scsi&m=117995785931981

James


