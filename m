From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] kill obsolete typedefs and wrappers from tmscsim
Date: Mon, 19 Jul 2004 22:09:13 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0407192143310.3926@poirot.grange>
References: <20040624081510.GA7950@lst.de> <Pine.LNX.4.60.0406242247500.4258@poirot.grange>
 <20040625095022.GA28822@lst.de> <Pine.LNX.4.60.0406252022400.3953@poirot.grange>
 <20040626111701.GA15170@lst.de> <Pine.LNX.4.60.0407042329320.2537@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:59310 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265649AbUGSUJR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jul 2004 16:09:17 -0400
In-Reply-To: <Pine.LNX.4.60.0407042329320.2537@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Sun, 4 Jul 2004, Guennadi Liakhovetski wrote:

> On Sat, 26 Jun 2004, Christoph Hellwig wrote:
>
>>> Do you want to rediff your 3rd patch yourself or should I do it?
>> 
>> I can rediff it.
>
> Christoph, attached is a port of your patch to my current (after the bug-2139 
> patch, they don't collide, however) tree. Please, have a look if I've done it 
> right.

Christoph, a bug in the "actual" (2.6.7) tmscsim error-handling was 
triggered by the patch from Kurt, removing the CONFIG_SCSI_REPORT_LUNS 
config-option, reported by Matthias Haase (he's also sent an email to 
you). My current tree, including your patch + a couple of other my 
irrelevant for this problem patches, doesn't have this problem! So, thanks 
again! And this is yet another reason to get your patch into the 
scsi-misc. I guess, your confirmation, that my port is ok, is needed.

> Notice, I didn't change the del_timer() call, I'd like to hear 
> somebody's comments to it, and, as said before, there are 2 more places, 
> where del_timer() is called, so, if indeed needed, they can be addressed 
> together in a separate patch.

That's still on the TODO.

Thanks
Guennadi
---
Guennadi Liakhovetski

