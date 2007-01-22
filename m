From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] SCSI seagate.c: remove SEAGATE_USE_ASM
Date: Mon, 22 Jan 2007 15:53:26 +0000
Message-ID: <20070122155326.4b0dbf30@localhost.localdomain>
References: <20070121191300.GL9093@stusta.de>
	<20070122151841.6d0473e4@localhost.localdomain>
	<20070122153813.GT9093@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52784 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751533AbXAVPoU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2007 10:44:20 -0500
In-Reply-To: <20070122153813.GT9093@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> > The C codepaths are essentially untested on this driver.
> 
> Has any part of this driver ever be tested with kernel 2.6?
> Or compiled with gcc 4?

The C code paths have never been tested at all, the asm ones certainly
worked in late 2.4, but I don't; have an ISA box any more.
