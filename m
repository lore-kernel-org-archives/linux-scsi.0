From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] tmscsim: 64-bit cleanup
Date: 05 Jun 2004 16:06:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086469564.2281.23.camel@mulgrave>
References: <Pine.LNX.4.44.0406052041470.1534-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:2014 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262003AbUFEVGJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Jun 2004 17:06:09 -0400
In-Reply-To: <Pine.LNX.4.44.0406052041470.1534-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Sat, 2004-06-05 at 15:37, Guennadi Liakhovetski wrote:
> Thanks for replies and explanations, James! But could you, please, just
> explain a bit more - what and how do I break with this patch? I just use a
> driver-private scatterlist struct (SRB.Segmentx) to set up a
> single-segment sg-list, and call pci_map_sg() on it. If I do it wrong - it
> could be fixed. But why it is bad in principle? Advantages - no need to
> check if sg is used for this particular command throughout the code.
> 
> But no problem. I'll redo the patch without private sg.

Actually, I haven't looked at the patch yet.  I was just answering the
question in the mail which I assumed was "can I alter these three
fields?" to which the answer is "no".  If the question is "can I read
these fields directly" the answer's yes.

James


