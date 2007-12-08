From: Nick Warne <nick@ukfsn.org>
Subject: Re: scsi_wait_scan Kconfig option
Date: Sat, 8 Dec 2007 16:21:22 +0000
Message-ID: <20071208162122.7e77601e@linuxamd.linicks.net>
References: <20071207191242.71a9cc3e@linuxamd.linicks.net>
	<475A9810.4070104@anagramm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s2.ukfsn.org ([217.158.120.143]:37780 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbXLHQVZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Dec 2007 11:21:25 -0500
In-Reply-To: <475A9810.4070104@anagramm.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Clemens Koller <clemens.koller@anagramm.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 08 Dec 2007 14:11:44 +0100
Clemens Koller <clemens.koller@anagramm.de> wrote:

> Nick Warne schrieb:
> > I am bringing this up again - primarily as I forgot about it after
> > patching my build tree ages ago:
> > 
> > http://lkml.org/lkml/2007/10/27/68

Subject: Re: Fw: scsi_wait_scan Kconfig option
Date: Fri, 7 Dec 2007 12:47:56 -0700

On Fri, Dec 07, 2007 at 07:39:53PM +0000, Nick Warne wrote:
> I try not to build a modular kernel, but only have modules ON due to
> nVidia (sigh).  So I was semi-surprised when I saw the scsi_wait_scan
> module being built again, yet NO WHERE in menuconfig is it present to
> turn OFF.  Even if I hand edit .config, make puts it back again...  

On Fri, 7 Dec 2007 12:47:56 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> You have modules on ... which means you might decide to load a scsi
> driver as a module.  Maybe one that isn't part of the source tree.
> The scsi_wait_scan module is only 1500 bytes.  Apart from a sense of
> ideological purity (odd in someone who chooses to use nVidia rather
> than, say, nv or nouveau), this really isn't a problem.
> 
> Please see the patch I sent some days ago, which does the very
> same thing: http://marc.info/?l=linux-kernel&m=119677244318528&w=2
> 
> True...

Well, that's two of us would that like to be able to stop it
building :-)

Nick
-- 
Free Software Foundation Associate Member 5508
