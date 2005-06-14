From: "J.A. Magallon" <jamagallon@able.es>
Subject: Re: [RFT][PATCH] aic79xx: remove busyq
Date: Tue, 14 Jun 2005 21:27:11 +0000
Message-ID: <1118784431l.7621l.0l@werewolf.able.es>
References: <20050529074620.GA26151@havoc.gtf.org>
	<1117488507l.7621l.0l@werewolf.able.es> <429B9311.9000608@pobox.com>
	<1118704487l.14239l.0l@werewolf.able.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp06.auna.com ([62.81.186.16]:39579 "EHLO smtp06.retemail.es")
	by vger.kernel.org with ESMTP id S261352AbVFNVij convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 17:38:39 -0400
In-Reply-To: <1118704487l.14239l.0l@werewolf.able.es> (from
	jamagallon@able.es on Tue Jun 14 01:14:47 2005)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "J.A. Magallon" <jamagallon@able.es>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


On 06.14, J.A. Magallon wrote:
> 
> On 05.31, Jeff Garzik wrote:
> > J.A. Magallon wrote:
> > > On 05.29, Jeff Garzik wrote:
> > > 
> > >>Can anyone with aic79xx hardware give me a simple "it works"
> > >>or "this breaks things" answer, for the patch below?
> > >>
> > >>This changes the aic79xx driver to use the standard Linux SCSI queueing
> > >>code, rather than its own.  After applying this patch, NO behavior
> > >>changes should be seen.
> > >>
> > >>The patch is against 2.6.12-rc5, but probably applies OK to recent 2.6.x
> > >>kernels.
> > >>
> > > 
> > > 
> > > Applied with even no offsets to -rc5-mm1. Booted and working fine:
> > 
> > Thanks a bunch!
> > 
> 
> Oops, don't be so happy.
> Following the other aic thread, I realized I applied the patch but booted on
> an U160 box :).
> 
> Will try shortly on a real 320.. sorry.
> 

Bad news, it just hangs forever after detecting the first SCSI disk.
No sysrq-p, sysrq-t, nothing.

--
J.A. Magallon <jamagallon()able!es>     \               Software is like sex:
werewolf!able!es                         \         It's better when it's free
Mandriva Linux release 2006.0 (Cooker) for i586
Linux 2.6.11-jam25 (gcc 4.0.0 (4.0.0-3mdk for Mandriva Linux release 2006.0))


