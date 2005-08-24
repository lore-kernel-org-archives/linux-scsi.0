From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libata: write cache and read ahead
Date: Wed, 24 Aug 2005 10:16:41 +0100
Message-ID: <20050824091641.GD26447@infradead.org>
References: <43085209.50405@torque.net> <430914C2.8030301@pobox.com> <43095EB3.2020202@torque.net> <430BAFD3.9000702@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:13285 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750809AbVHXJQv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 05:16:51 -0400
Content-Disposition: inline
In-Reply-To: <430BAFD3.9000702@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: dougg@torque.net, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

On Tue, Aug 23, 2005 at 07:22:59PM -0400, Luben Tuikov wrote:
> On 08/22/05 01:12, Douglas Gilbert wrote:
> > I was surprised how much code needed changing.
> > With MODE SELECT's issues with libata addressed
> > various other SAT "extras" should be much easier
> > to implement. That should make libata more attractive
> > as a SAT layer for SAS LLDDs (that don't do it already
> > in firmware).
> 
> Doug, how about never needing a SAT layer for SAS LLDDs
> for ATA/ATAPI devices.
> 
> Would you object if I "give" you a "domain device" to which
> you can send FISes (+ the packet if ATAPI) through
> a SAM-4 intefrace: Execute Task + TMFs?

Personally I think that would be nice, but when I mentioned the basic idea
(sending FISes through BLOCK_PC block later commands and let the scsi layer
handle then as vendor-specific commands) Jeff didn't like that because
then we'd need a non-sd upper driver although using the scsi midlayer.

