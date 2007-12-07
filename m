From: Nick Warne <nick@ukfsn.org>
Subject: Re: scsi_wait_scan Kconfig option
Date: Fri, 7 Dec 2007 21:31:09 +0000
Message-ID: <20071207213109.5a7a23fc@linuxamd.linicks.net>
References: <20071207193953.0c544044@linuxamd.linicks.net>
	<20071207194756.GB28914@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s2.ukfsn.org ([217.158.120.143]:41833 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbXLGVbd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2007 16:31:33 -0500
In-Reply-To: <20071207194756.GB28914@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Hi Matthew,

On Fri, 7 Dec 2007 12:47:56 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Fri, Dec 07, 2007 at 07:39:53PM +0000, Nick Warne wrote:
> > I try not to build a modular kernel, but only have modules ON due to
> > nVidia (sigh).  So I was semi-surprised when I saw the
> > scsi_wait_scan module being built again, yet NO WHERE in menuconfig
> > is it present to turn OFF.  Even if I hand edit .config, make puts
> > it back again...
> 
> You have modules on ... which means you might decide to load a scsi
> driver as a module.  Maybe one that isn't part of the source tree.
> The scsi_wait_scan module is only 1500 bytes.  Apart from a sense of
> ideological purity (odd in someone who chooses to use nVidia rather
> than, say, nv or nouveau), this really isn't a problem.

Alas the card I have isn't supported, but that debate isn't for here.

OK, I only have SCSI set for USB storage etc.  I find it strange that
this one and only option in the whole of Kconfig builds a module, and
yet, even though I know I will never need it, I can't stop it.

Surely if people build their own kernels, they should know (and) be
allowed to configure such options?

Nick 
-- 
Free Software Foundation Associate Member 5508
