From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/42 RESEND+NEW] Target updates for May 27
Date: Sat, 28 May 2011 12:09:17 -0700
Message-ID: <1306609757.23461.524.camel@haakon2.linux-iscsi.org>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>
	 <1306534540.23461.203.camel@haakon2.linux-iscsi.org>
	 <20110527223538.GA26592@infradead.org>
	 <1306539563.23461.229.camel@haakon2.linux-iscsi.org>
	 <20110528074333.GA22382@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48628 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab1E1TRg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 May 2011 15:17:36 -0400
In-Reply-To: <20110528074333.GA22382@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-iscsi-target-dev@googlegroups.com, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Sat, 2011-05-28 at 03:43 -0400, Christoph Hellwig wrote:
> On Fri, May 27, 2011 at 04:39:23PM -0700, Nicholas A. Bellinger wrote:
> > I will send these out as they are committed into lio-core-2.6.git for
> 
> Nick, the whole point is to get things reviewed before they are
> commited.
> 

Committed where..?  Andy has been sending lots cleanup patches regularly
the last months, but because of the very slow pace of target changes
moving into mainline these all end up going into lio-core-2.6.git.

I don't have time to seperate out all of the cleanup items that depend
upon iscsi-target from Andy, make drastic changes that James wants for
iscsi-target at the last minute of a merge window, and get everyone's
signoff on linux-scsi for everything into goes into lio-core-2.6.git.
It's not physically possible.

This workflow is quickly becoming unmanageable and extremely frustrating
when people are moving forward on lio-core-2.6.git, and we still cant
agree on basic design of iscsi-target for mainline.  I am not advocating
for less review, I want more review but the current workflow is
inefficent for the amount of changes that full time developers like Andy
are producing.

--nab


