From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [LSF/MM TOPIC] LIO/SCST Merger
Date: Thu, 28 Jan 2016 01:01:58 -0800
Message-ID: <20160128090158.GA26834@infradead.org>
References: <56A9043B.7030207@sandisk.com>
 <1453963019.6746.244.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934456AbcA1JCB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 04:02:01 -0500
Content-Disposition: inline
In-Reply-To: <1453963019.6746.244.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Everyone calm down.

I'm going to downvote this topic just like last year with my PC hat on
as I think it's a) not relevant or usefully discussable at LSF and b)
framed the wrong way.

But let's forget about unification and think about fixing up lose ends
and looking at other implementations and other preople experiences
here.  While I'd never want to take SCST as a whole into the kernel tree
there are plenty of good idea to look at, and Bart has been trying for
quite a while to merge a lot of the concepts into the in-kernel SCSI
target stack and has meet an incredibly hostility.  And I have the
impression as lot of that is due to him beeing Bart - I've done some
quite similar things where I took concepts from SCST or other
implementations and opnly meet minor if any resistance.

Maybe we should have a discussion about equalt treatment on the
target-devel list instead? :)
