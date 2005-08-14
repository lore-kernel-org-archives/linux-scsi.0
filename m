From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.13
Date: Sun, 14 Aug 2005 21:33:05 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0508142121000.4594@poirot.grange>
References: <1123184634.5026.58.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:44975 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751068AbVHNTe0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Aug 2005 15:34:26 -0400
In-Reply-To: <1123184634.5026.58.camel@mulgrave>
Content-ID: <Pine.LNX.4.60.0508142124061.4594@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi

On Thu, 4 Aug 2005, James Bottomley wrote:

> This is my (hopefully final) collection of safe driver updates and bug
> fixes for 2.6.13.

Just to make sure everyone agrees on this - there's currently a know bug 
in dc395x with highmem reported by Pierre Ossman in thread "Kernel panic 
with dc395x in 2.6.12.2" on linux-scsi. It is also trivial to reproduce on 
non-highmem machines. It was there also in 2.6.12. It only was hit by one 
person because not many use dc395x controlled cards in highmem machines 
today. The fix is known - at least revert my patch to dc395x commited to 
2.6.12-rc5. This will fix this bug, leaving another one, which is much 
harder to hit. There was only one person who hit it, but he cannot test 
any more patches - the hardware is not there any more. I think I have a 
fix for that one too, but that's another story. So, I would say it would 
be worth it reverting that patch before 2.6.13, but, that's because I feel 
personal responsibility for that bug:-)

Thanks
Guennadi
---
Guennadi Liakhovetski
