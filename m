From: James Bottomley <jejb@steeleye.com>
Subject: Re: [PATCH] merge scsiiom.c into tmscsim.c
Date: 09 Oct 2004 08:02:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097326958.2141.2.camel@mulgrave>
References: <20041003134714.GA1623@lst.de>  <20041009122946.GA19272@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:17539 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266786AbUJINCs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Oct 2004 09:02:48 -0400
In-Reply-To: <20041009122946.GA19272@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: g.liakhovetski@gmx.de, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-10-09 at 07:29, Christoph Hellwig wrote:
> On Sun, Oct 03, 2004 at 03:47:14PM +0200, Christoph Hellwig wrote:
> > might be a good time to get rid of that clumsy include .c file into
> > another one thing.  (Also please bk rm scsiiom.c afterwards)
> 
> And here's a patch ontop that restores's Al's sparse fixes done in
> scsiiom.c (the old patch still applies and works without this one,
> but without it you get a few more sparse warnings):

I can't apply this patch without previously applying the tmscsim: remove
remaining INQUIRY sniffing.  In reply to that patch Guennadi said:

    So, I just wanted to let the so far submitted patches settle down a
    bit, at least hear some reaction to them, and then submit this one.
    But yours looks a bit better: I overlooked the possibility to do
    srb->pcmd->device, and added a dcb->sdev pointer to get to sdtr. So,
    be it yours.
    
Which I interpreted to mean wait a while before applying.

So, I can either apply both or neither.  Which is it to be?

James


