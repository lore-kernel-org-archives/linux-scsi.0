From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] SCSI seagate.c: remove SEAGATE_USE_ASM
Date: Mon, 22 Jan 2007 15:18:41 +0000
Message-ID: <20070122151841.6d0473e4@localhost.localdomain>
References: <20070121191300.GL9093@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53674 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751889AbXAVPJm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2007 10:09:42 -0500
In-Reply-To: <20070121191300.GL9093@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, 21 Jan 2007 20:13:00 +0100
Adrian Bunk <bunk@stusta.de> wrote:

> Using assembler code for performance in drivers might have been a good 
> idea 15 years ago when this code was written, but with today's compilers 
> that's unlikely to be an advantage.
> 
> Besides this, it also hurts the readability.
> 
> Simply use the C code that was already there as an alternative.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
					"stosb\n\t"

NAK

The C codepaths are essentially untested on this driver.

Alan
