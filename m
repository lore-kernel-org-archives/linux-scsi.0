From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7] st implement tape statistics
Date: Tue, 5 May 2015 21:30:47 -0700
Message-ID: <20150506043047.GA2077@infradead.org>
References: <DDB9C85B850785449757F9914A034FCB3BFA45A3@G9W0766.americas.hpqcorp.net>
 <20150505174241.GA6033@infradead.org>
 <DDB9C85B850785449757F9914A034FCB3BFA96F7@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41889 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759060AbbEFEat (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2015 00:30:49 -0400
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BFA96F7@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Laurence Oberman (loberman@redhat.com)" <loberman@redhat.com>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>

On Wed, May 06, 2015 at 01:11:26AM +0000, Seymour, Shane M wrote:
> "The tape driver does not have access to the block device i/o statistics because the tapes are not block devices but character devices. They use the Linux block subsystem enough to do i/o but this does not include access to the statistics counters.
> 
> ... One alternative is, of course, to tie the st driver more into the Linux block device system. I have looked into this several times but have never seen how to do this in a simple enough way."

I know the architecture pretty well, but the question is if we can
export some of that functionality so that it works for character devices
nodes that driver a request_queue.  Note that it was formualted as a
questions as thast change seems obvious but might not be feasible for
one reason or another.  If you looked at it and consider it not doable
or at least not worthwhile for good reasons document those in the patch
description.
