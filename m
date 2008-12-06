From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Fri, 5 Dec 2008 23:12:00 -0700
Message-ID: <20081205231200.ecc39dc5.zaitcev@redhat.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>
	<20081203100643.GA29340@infradead.org>
	<1228316941.5551.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43360 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYLFGM0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Dec 2008 01:12:26 -0500
In-Reply-To: <1228316941.5551.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bzolnier@gmail.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org

On Wed, 03 Dec 2008 09:09:00 -0600, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> git log tells me ide-scsi has been updated quite a bit recently, but it
> mostly looks to be fallout around the drivers/ide churn.  Can we get ide
> maintainer's buy in for this (I think they've been maintaining ide-tape
> and ide-cd in preference to ide-scsi)?

They must be bonkers to do it. I fixed a couple of bugs in ide-tape
and it was one of the worst drivers I worked on, ever (worse than
floppy.c, I kid you not). It definitely must die before ide-scsi.
Fortunately, I solved this issue by hooking my tape to USB bridge,
or else I'd be up in arms and wanting Tomo's blood.

-- Pete
