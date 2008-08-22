From: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: [PATCH 3/4] drop vmerge accounting
Date: Fri, 22 Aug 2008 11:29:42 +0200
Message-ID: <20080822112942.67404141@mjolnir.drzeus.cx>
References: <20080808055405.GF20055@kernel.dk>
	<20080808151147J.fujita.tomonori@lab.ntt.co.jp>
	<20080808061537.GI20055@kernel.dk>
	<20080808152845N.fujita.tomonori@lab.ntt.co.jp>
	<20080808063527.GJ20055@kernel.dk>
	<Pine.LNX.4.64.0808081247430.11647@devserv.devel.redhat.com>
	<Pine.LNX.4.64.0808081254000.11647@devserv.devel.redhat.com>
	<20080815094800.GI20055@kernel.dk>
	<Pine.LNX.4.64.0808151418240.24727@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server.drzeus.cx ([85.8.24.28]:41959 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751989AbYHVJ3q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2008 05:29:46 -0400
In-Reply-To: <Pine.LNX.4.64.0808151418240.24727@hs20-bc2-1.build.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net

On Fri, 15 Aug 2008 14:23:16 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> The next patch 4 drops the hw_segments logic from MMC card subsystem.
> 

What happened to this one? It seems I didn't get a cc for that one.
Fortunately I could have a look at marc.info and find it.

Both patches seem fine to me, so you can add:

Acked-by: Pierre Ossman <drzeus@drzeus.cx>

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
