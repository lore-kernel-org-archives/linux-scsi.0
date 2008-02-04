From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 4 Feb 2008 15:27:42 -0800 (PST)
Message-ID: <alpine.LFD.1.00.0802041521130.3034@hp.linux-foundation.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com> <1201639331.3069.58.camel@localhost.localdomain> <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net> <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net>
 <1202144767.3096.38.camel@localhost.localdomain> <47A7488B.4080000@vlnb.net> <1202145901.3096.49.camel@localhost.localdomain> <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org> <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org> <20080204224314.113afe7b@core> <47A79A10.4070706@garzik.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755596AbYBDX2a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 18:28:30 -0500
In-Reply-To: <47A79A10.4070706@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>



On Mon, 4 Feb 2008, Jeff Garzik wrote:
> 
> For years I have been hoping that someone will invent a simple protocol (w/
> strong auth) that can transit ATA and SCSI commands and responses. Heck, it
> would be almost trivial if the kernel had a TLS/SSL implementation.

Why would you want authorization? If you don't use IP (just ethernet 
framing), then 99% of the time the solution is to just trust the subnet. 

So most people would never want TLS/SSL, and the ones that *do* want it 
would probably also want IP routing, so you'd actually be better off with 
a separate higher-level bridging protocol rather than have TLS/SSL as part 
of the actual packet protocol.

So don't add complexity. The beauty of ATA-over-ethernet is exactly that 
it's simple and straightforward.

(Simple and straightforward is also nice for actually creating devices 
that are the targets of this. I just *bet* that an iSCSI target device 
probably needs two orders of magnitude more CPU power than a simple AoE 
thing that can probably be done in an FPGA with no real software at all).

Whatever. We have now officially gotten totally off topic ;)

		Linus
