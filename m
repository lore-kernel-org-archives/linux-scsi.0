From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] t128: Indent and add printk levels
Date: Thu, 26 Jul 2007 20:05:14 +0100
Message-ID: <20070726200514.3e9e8e26@the-village.bc.nu>
References: <20070726185044.76b17661@the-village.bc.nu>
	<20070726175108.GH19275@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57631 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S936364AbXGZS6l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 14:58:41 -0400
In-Reply-To: <20070726175108.GH19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org

On Thu, 26 Jul 2007 11:51:08 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Thu, Jul 26, 2007 at 06:50:44PM +0100, Alan Cox wrote:
> > -    [4] __initdata = {{0, IRQ_AUTO}, {0, IRQ_AUTO},
> > -        {0 ,IRQ_AUTO}, {0, IRQ_AUTO}};
> > +[4] __initdata = { {

Fair comment - fixed - will send a replacement diff later
