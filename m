From: Matteo Tescione <matteo@rmnet.it>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux
 kernel
Date: Tue, 05 Feb 2008 05:43:10 +0100
Message-ID: <C3CDA7EE.5784%matteo@rmnet.it>
References: <alpine.LFD.1.00.0802041620110.3237@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from garbage.rmnet.it ([82.145.99.230]:46401 "EHLO garbage.rmnet.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbYBEE4C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Feb 2008 23:56:02 -0500
In-Reply-To: <alpine.LFD.1.00.0802041620110.3237@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Matt Mackall <mpm@selenic.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Alan Cox <alan@lxorguk.ukuu.org.uk>

Hi all,
And sorry for intrusion, i am not a developer but i work everyday with iscsi
and i found it fantastic.
Altough Aoe, Fcoe and so on could be better, we have to look in real world
implementations what is needed *now*, and if we look at vmware world,
virtual iron, microsoft clustering etc, the answer is iSCSI.
And now, SCST is the best open-source iSCSI target. So, from an end-user
point of view, what are the really problems to not integrate scst in the
mainstream kernel?

Just my two cent,
--
So long and thank for all the fish
--
#Matteo Tescione
#RMnet srl


> 
> 
> On Mon, 4 Feb 2008, Matt Mackall wrote:
>> 
>> But ATAoE is boring because it's not IP. Which means no routing,
>> firewalls, tunnels, congestion control, etc.
> 
> The thing is, that's often an advantage. Not just for performance.
> 
>> NBD and iSCSI (for all its hideous growths) can take advantage of these
>> things.
> 
> .. and all this could equally well be done by a simple bridging protocol
> (completely independently of any AoE code).
> 
> The thing is, iSCSI does things at the wrong level. It *forces* people to
> use the complex protocols, when it's a known that a lot of people don't
> want it. 
> 
> Which is why these AoE and FCoE things keep popping up.
> 
> It's easy to bridge ethernet and add a new layer on top of AoE if you need
> it. In comparison, it's *impossible* to remove an unnecessary layer from
> iSCSI.
> 
> This is why "simple and low-level is good". It's always possible to build
> on top of low-level protocols, while it's generally never possible to
> simplify overly complex ones.
> 
> Linus
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> Scst-devel mailing list
> Scst-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/scst-devel
> 


