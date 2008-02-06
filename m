From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Tue, 05 Feb 2008 16:17:10 -0800
Message-ID: <1202257030.2220.90.camel@haakon2.linux-iscsi.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net>	<47A7049A.9000105@vlnb.net>
	 <1202139015.3096.5.camel@localhost.localdomain>	<47A73C86.3060604@vlnb.net>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
	 <20080204224314.113afe7b@core> <47A79A10.4070706@garzik.org>
	 <47A8B29B.8050406@vlnb.net>  <47A8B510.8000807@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:24232 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759558AbYBFARj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 19:17:39 -0500
In-Reply-To: <47A8B510.8000807@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Julian Satran <Julian_Satran@il.ibm.com>

On Tue, 2008-02-05 at 14:12 -0500, Jeff Garzik wrote:
> Vladislav Bolkhovitin wrote:
> > Jeff Garzik wrote:
> >> iSCSI is way, way too complicated. 
> > 
> > I fully agree. From one side, all that complexity is unavoidable for 
> > case of multiple connections per session, but for the regular case of 
> > one connection per session it must be a lot simpler.
> 
> 
> Actually, think about those multiple connections...  we already had to 
> implement fast-failover (and load bal) SCSI multi-pathing at a higher 
> level.  IMO that portion of the protocol is redundant:   You need the 
> same capability elsewhere in the OS _anyway_, if you are to support 
> multi-pathing.
> 
> 	Jeff
> 
> 

Hey Jeff,

I put a whitepaper on the LIO cluster recently about this topic.. It is
from a few years ago but the datapoints are very relevant.

http://linux-iscsi.org/builds/user/nab/Inter.vs.OuterNexus.Multiplexing.pdf

The key advantage to MC/S and ERL=2 has always been that they are
completely OS independent.  They are designed to work together and
actually benefit from one another.

They are also are protocol independent between Traditional iSCSI and
iSER.

--nab

PS: A great thanks for my former colleague Edward Cheng for putting this
together.

> 
> 

