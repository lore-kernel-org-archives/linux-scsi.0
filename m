From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Wed, 6 Jul 2011 12:53:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107061251580.1995-100000@iolanthe.rowland.org>
References: <CAL1RGDW41oxoES=c+g9oLdx4mriBiEtxRpv=OD7yEJ6XKdU_fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:36837 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751987Ab1GFQxL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2011 12:53:11 -0400
In-Reply-To: <CAL1RGDW41oxoES=c+g9oLdx4mriBiEtxRpv=OD7yEJ6XKdU_fQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>

On Wed, 6 Jul 2011, Roland Dreier wrote:

> On Wed, Jul 6, 2011 at 7:24 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > Problem
> > most likely missing block guards on blk_execute_req() ... no check for
> > QUEUE_DEAD.
> 
> blk_execute_req() doesn't exist.  Do you mean __blk_run_queue()?

He probably meant blk_execute_rq_nowait().  The test has to be done 
before the elevator is accessed.

Alan Stern

