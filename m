From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] merge scsiiom.c into tmscsim.c
Date: Sat, 9 Oct 2004 21:18:31 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0410092110340.2812@poirot.grange>
References: <20041003134714.GA1623@lst.de>  <20041009122946.GA19272@lst.de>
 <1097326958.2141.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:18908 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267301AbUJITTY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2004 15:19:24 -0400
In-Reply-To: <1097326958.2141.2.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 9 Oct 2004, James Bottomley wrote:

> On Sat, 2004-10-09 at 07:29, Christoph Hellwig wrote:
> 
> I can't apply this patch without previously applying the tmscsim: remove
> remaining INQUIRY sniffing.  In reply to that patch Guennadi said:
> 
>     So, I just wanted to let the so far submitted patches settle down a
>     bit, at least hear some reaction to them, and then submit this one.
>     But yours looks a bit better: I overlooked the possibility to do
>     srb->pcmd->device, and added a dcb->sdev pointer to get to sdtr. So,
>     be it yours.
>     
> Which I interpreted to mean wait a while before applying.
> 
> So, I can either apply both or neither.  Which is it to be?

Sorry, James, Christoph. I wasn't clear enough in that my email. I just 
explained that I also had a patch to address the same problem, and just 
was waiting for some reaction to the previous pretty risky patch before 
submitting further ones. And I did say that Christoph's patch was a bit 
better. So, if you and Christoph have nothing against my "remove internal 
command queueing" patch, then we can move further, so, please, apply all 
(3 so far, I think?) Christoph's patches too.

Thanks
Guennadi
---
Guennadi Liakhovetski

