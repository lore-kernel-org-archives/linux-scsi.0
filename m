From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 21/24][RFC] scsi_tgt: use of sense accessors
Date: Wed, 6 Feb 2008 01:53:07 +0900
Message-ID: <20080206015308F.tomof@acm.org>
References: <1202147595-5400-1-git-send-email-bharrosh@panasas.com>
	<20080205162133.GC1931@osc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50922 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbYBEQ72 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Feb 2008 11:59:28 -0500
In-Reply-To: <20080205162133.GC1931@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pw@osc.edu
Cc: bharrosh@panasas.com, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, hch@infradead.org, jens.axboe@oracle.com, jeff@garzik.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.orgfujita.tomonori@lab.ntt.co.jp

On Tue, 5 Feb 2008 11:21:33 -0500
Pete Wyckoff <pw@osc.edu> wrote:

> bharrosh@panasas.com wrote on Mon, 04 Feb 2008 19:53 +0200:
> >   FIXME: I need help with this driver (Pete?)
> >     I used scsi_sense() in a none const way. But since
> >     scsi_tgt is the ULD here, it can just access it's own sense
> >     buffer directly. I did not use scsi_eh_cpy_sense() because
> >     I did not want the extra copy. Pete will want to use a 260
> >     bytes buffer here.
> > 
> > Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> > Need-help-from: Pete Wyckoff <pw@osc.edu>
> 
> FYI, I never use scsi_tgt.  Only just pure userspace on the target,
> and a dumb ethernet NIC that does not know it is speaking any form
> of SCSI.

Seems that many people misunderstand STGT iSCSI (and iSER), FCoE, and
SRP (not implemented yet) software target drivers. They don't use the
tgt kernel module. They just run in user space like user-space nfs
daemon.
