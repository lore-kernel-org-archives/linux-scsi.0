From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 4 Feb 2008 16:24:33 -0800 (PST)
Message-ID: <alpine.LFD.1.00.0802041620110.3237@woody.linux-foundation.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>  <1201639331.3069.58.camel@localhost.localdomain>  <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net>  <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net>
  <1202144767.3096.38.camel@localhost.localdomain>  <47A7488B.4080000@vlnb.net>  <1202145901.3096.49.camel@localhost.localdomain>  <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>  <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>  <20080204224314.113afe7b@core> <1202170060.17934.142.camel@cinder.waste.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52942 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756881AbYBEAZX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 19:25:23 -0500
In-Reply-To: <1202170060.17934.142.camel@cinder.waste.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>



On Mon, 4 Feb 2008, Matt Mackall wrote:
> 
> But ATAoE is boring because it's not IP. Which means no routing,
> firewalls, tunnels, congestion control, etc.

The thing is, that's often an advantage. Not just for performance.

> NBD and iSCSI (for all its hideous growths) can take advantage of these
> things.

.. and all this could equally well be done by a simple bridging protocol 
(completely independently of any AoE code).

The thing is, iSCSI does things at the wrong level. It *forces* people to 
use the complex protocols, when it's a known that a lot of people don't 
want it. 

Which is why these AoE and FCoE things keep popping up. 

It's easy to bridge ethernet and add a new layer on top of AoE if you need 
it. In comparison, it's *impossible* to remove an unnecessary layer from 
iSCSI.

This is why "simple and low-level is good". It's always possible to build 
on top of low-level protocols, while it's generally never possible to 
simplify overly complex ones.

		Linus
