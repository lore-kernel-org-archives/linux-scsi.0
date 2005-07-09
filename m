From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 09 Jul 2005 18:37:10 +0200
Message-ID: <1120927030.3176.39.camel@laptopd505.fenrus.org>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>
	 <1120922306.5008.5.camel@mulgrave> <20050709162712.GB27347@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:20197 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261598AbVGIQh2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Jul 2005 12:37:28 -0400
In-Reply-To: <20050709162712.GB27347@phunnypharm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: linux1394-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, James Bottomley <James.Bottomley@SteelEye.com>

On Sat, 2005-07-09 at 12:27 -0400, Ben Collins wrote:
> If it was orphaned it was done so mistakenly. I maintain that code, and
> linux1394.
> 
> Aside from that, the the change was pushed into the mainstream kernel
> without going through our repository, which means it would have been
> caught before going to all of our users (most of users of ieee1394 on
> linux use it for sbp2).
> 
> THese changes break sbp2, and we'll need to revert them in the main stream
> kernel until the patch is tested and fixed in our tree.
> 

you can't revert the changes done to the locking really.... the API
changed. Also I can't imagine these breaking at all.

Does ieee1394 tree have a git tree that james could pull? (like akpm
pulls many trees I guess at least sbp2 should be pulled into the scsi
tree)


