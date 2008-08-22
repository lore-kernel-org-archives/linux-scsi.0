From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 3/4] drop vmerge accounting
Date: Fri, 22 Aug 2008 11:33:22 +0200
Message-ID: <20080822093322.GF20055@kernel.dk>
References: <20080808055405.GF20055@kernel.dk> <20080808151147J.fujita.tomonori@lab.ntt.co.jp> <20080808061537.GI20055@kernel.dk> <20080808152845N.fujita.tomonori@lab.ntt.co.jp> <20080808063527.GJ20055@kernel.dk> <Pine.LNX.4.64.0808081247430.11647@devserv.devel.redhat.com> <Pine.LNX.4.64.0808081254000.11647@devserv.devel.redhat.com> <20080815094800.GI20055@kernel.dk> <Pine.LNX.4.64.0808151418240.24727@hs20-bc2-1.build.redhat.com> <20080822112942.67404141@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [93.163.65.50] ([93.163.65.50]:15949 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759299AbYHVJdZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2008 05:33:25 -0400
Content-Disposition: inline
In-Reply-To: <20080822112942.67404141@mjolnir.drzeus.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Mikulas Patocka <mpatocka@redhat.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net

On Fri, Aug 22 2008, Pierre Ossman wrote:
> On Fri, 15 Aug 2008 14:23:16 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > The next patch 4 drops the hw_segments logic from MMC card subsystem.
> > 
> 
> What happened to this one? It seems I didn't get a cc for that one.
> Fortunately I could have a look at marc.info and find it.
> 
> Both patches seem fine to me, so you can add:
> 
> Acked-by: Pierre Ossman <drzeus@drzeus.cx>

Thanks, it'll go into for-2.6.28 once Mikulas resends it.

-- 
Jens Axboe

