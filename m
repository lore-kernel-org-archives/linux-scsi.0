From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [2.6 patch] remove the broken SCSI_SEAGATE driver
Date: Mon, 18 Dec 2006 09:47:02 +0100
Message-ID: <1166431702.3365.934.camel@laptopd505.fenrus.org>
References: <20061212162238.GR28443@stusta.de>
	 <1165966274.5903.56.camel@mulgrave.il.steeleye.com>
	 <20061213000902.GD28443@stusta.de> <m3wt4tp9ka.fsf@defiant.localdomain>
	 <1166198454.2846.10.camel@mulgrave.il.steeleye.com>
	 <m3ac1mb88s.fsf@defiant.localdomain>
	 <1166386966.9647.20.camel@mulgrave.il.steeleye.com>
	 <m3tzzu9q7k.fsf@defiant.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57751 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbWLRLlb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Dec 2006 06:41:31 -0500
In-Reply-To: <m3tzzu9q7k.fsf@defiant.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, 2006-12-17 at 22:18 +0100, Krzysztof Halasa wrote:
> James Bottomley <James.Bottomley@SteelEye.com> writes:
> 
> > One of the touted benefits of Linux is that we run on old hardware.
> > Unless the driver is demonstrably wrong (and they do become so as the
> > APIs evolve)
> 
> Sure, I expect they do - but nobody is able to check.

if a tree falls in a forest but there's nobody around to hear it, does
it make a sound?

This sort of heisenbug questions aren't solved by "nobody hears it so
lets chop down the forest to make houses out of the wood" answers...


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

