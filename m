From: Hugh Dickins <hugh@veritas.com>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Sat, 4 Feb 2006 14:46:44 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0602041439340.8478@goblin.wat.veritas.com>
References: <Pine.LNX.4.63.0512271807130.4955@kai.makisara.local>
 <20060104172727.GA320@tau.solarneutrino.net> <Pine.LNX.4.63.0601042334310.5087@kai.makisara.local>
 <20060105201249.GB1795@tau.solarneutrino.net> <Pine.LNX.4.64.0601051312380.3169@g5.osdl.org>
 <20060109033149.GC283@tau.solarneutrino.net> <Pine.LNX.4.64.0601082000450.3169@g5.osdl.org>
 <Pine.LNX.4.61.0601090933160.7632@goblin.wat.veritas.com>
 <20060109185350.GG283@tau.solarneutrino.net> <Pine.LNX.4.61.0601091922550.15426@goblin.wat.veritas.com>
 <20060118001252.GB821@tau.solarneutrino.net> <Pine.LNX.4.61.0601181556050.9110@goblin.wat.veritas.com>
 <Pine.LNX.4.61.0602031842290.14065@goblin.wat.veritas.com>
 <Pine.LNX.4.63.0602041347320.3923@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from silver.veritas.com ([143.127.12.111]:3752 "EHLO
	silver.veritas.com") by vger.kernel.org with ESMTP id S932500AbWBDOqJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Feb 2006 09:46:09 -0500
In-Reply-To: <Pine.LNX.4.63.0602041347320.3923@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Ryan Richter <ryan@tau.solarneutrino.net>, Linus Torvalds <torvalds@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, Nick Piggin <nickpiggin@yahoo.com.au>, Andrew Morton <akpm@osdl.org>, Roland Dreier <rdreier@cisco.com>, Brian King <brking@us.ibm.com>, Willem Riede <osst@riede.org>, Doug Gilbert <dougg@torque.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 4 Feb 2006, Kai Makisara wrote:
> On Fri, 3 Feb 2006, Hugh Dickins wrote:
> > > The st problem (Bad page state,
> > > mapcount 2 while count 0, from sgl_unmap_user_pages) ought to be a lot
> > > easier to debug than a random reboot: but I've still no suggestion.
> > 
> > I guessed it last week, Ryan verified that booting with "iommu=nomerge"
> > worked around it, and then that the 2.6.15 patch below fixes it.
> 
> I have tested the patch and did not find any problems. I suppose you will 

Thanks.

> send this to the stable team for inclusion into 2.6.15.x? You can add

Yes, this one does fit the criteria for stable (even though the patch
fortuitously turns out not to be necessary in 2.6.16): it fixes a serious
observed user problem.  Not sure what to do with the associated patches
to other drivers though, since those problems have not been knowingly
observed: probably best leave them to maintainer's discretion.

> Signed-off-by: Kai Makisara <Kai.Makisara@kolumbus.fi>

Thanks,
Hugh
