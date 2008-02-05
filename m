From: Matt Mackall <mpm@selenic.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 04 Feb 2008 18:45:14 -0600
Message-ID: <1202172314.17934.161.camel@cinder.waste.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net>
	 <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
	 <20080204224314.113afe7b@core>
	 <1202170060.17934.142.camel@cinder.waste.org>
	 <alpine.LFD.1.00.0802041620110.3237@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from waste.org ([66.93.16.53]:57753 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643AbYBEAqW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Feb 2008 19:46:22 -0500
In-Reply-To: <alpine.LFD.1.00.0802041620110.3237@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>


On Mon, 2008-02-04 at 16:24 -0800, Linus Torvalds wrote:
> 
> On Mon, 4 Feb 2008, Matt Mackall wrote:
> > 
> > But ATAoE is boring because it's not IP. Which means no routing,
> > firewalls, tunnels, congestion control, etc.
> 
> The thing is, that's often an advantage. Not just for performance.
> 
> > NBD and iSCSI (for all its hideous growths) can take advantage of these
> > things.
> 
> .. and all this could equally well be done by a simple bridging protocol 
> (completely independently of any AoE code).
> 
> The thing is, iSCSI does things at the wrong level. It *forces* people to 
> use the complex protocols, when it's a known that a lot of people don't 
> want it. 

I frankly think NBD is at a pretty comfortable level. It's internally
very simple (and hardware-agnostic). And moderately easy to do in
silicon.

But I'm not going to defend iSCSI. I worked on the first implementation
(what became the Cisco iSCSI driver) and I have no love for iSCSI at
all. It should have been (and started out as) a nearly trivial
encapsulation of SCSI over TCP much like ATA over Ethernet but quickly
lost the plot when committees got ahold of it.

-- 
Mathematics is the supreme nostalgia of our time.

