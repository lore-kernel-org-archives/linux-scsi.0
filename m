From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] add help to WAIT_SCAN option
Date: Sat, 26 May 2007 14:44:47 -0600
Message-ID: <20070526204447.GM5798@parisc-linux.org>
References: <20070526191127.GB7080@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49507 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760378AbXEZUot (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 May 2007 16:44:49 -0400
Content-Disposition: inline
In-Reply-To: <20070526191127.GB7080@colo.lackof.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Thibaut VARENE <T-Bone@parisc-linux.org>

On Sat, May 26, 2007 at 01:11:27PM -0600, Grant Grundler wrote:
> Thibaut Varene's parisc box didn't find the root disk.
> Problem is he had ASYNC_SCAN enabled and the required SYM2 driver builtin
> but the root disk wasn't discovered before the kernel wanted to mount root.
> Oh, and he (like many folks who build their own kernels) didn't use
> an initrd or initramfs. So no chance to load scsi_wait_scan module.

I don't know what Thibaut's problem was, but this explanation is
definitely incorrect.  If you build in the sym2 driver and the scsi
core, then we wait for the discs to be discovered automatically.
