From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Linux 2.6.23-rc3
Date: Tue, 14 Aug 2007 05:24:30 -0600
Message-ID: <20070814112429.GL16277@parisc-linux.org>
References: <alpine.LFD.0.999.0708122143240.30176@woody.linux-foundation.org> <46C1717E.3030908@linpro.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60387 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbXHNLYb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 07:24:31 -0400
Content-Disposition: inline
In-Reply-To: <46C1717E.3030908@linpro.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tore Anderson <tore@linpro.no>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James.Smart@Emulex.Com

On Tue, Aug 14, 2007 at 11:10:22AM +0200, Tore Anderson wrote:
>   I gave it a spin, and got quite a few troubles that appears related to
>  the lpfc driver.  I don't know if these problems happened due to the
>  recent update as the latest kernel I ran before was 2.6.20 (where I
>  never saw problems like these).  First I see that something failed when
>  the volumes on the SAN (on a Sun StorageTek 6140 / Engenio 3994) is
>  registered, causing two errors errors such as:

You didn't seem to include your .config, but I assume you're using async
scanning.  Could you try including this patch:

http://marc.info/?l=linux-scsi&m=118289275414202&w=2

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
