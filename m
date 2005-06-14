From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Mon, 13 Jun 2005 21:20:22 -0500
Message-ID: <1118715622.5079.88.camel@mulgrave>
References: <20050607085710.GB9230@gmail.com>
	 <1118590709.4967.6.camel@mulgrave> <20050613145000.GA12057@gmail.com>
	 <1118674783.5079.9.camel@mulgrave> <20050613183719.GA8653@gmail.com>
	 <1118695847.5079.41.camel@mulgrave> <20050613213307.GA8534@gmail.com>
	 <1118699191.5079.49.camel@mulgrave> <20050613215923.GA8629@gmail.com>
	 <1118700284.5079.52.camel@mulgrave>  <20050613222527.GB8629@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:21901 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261349AbVFNCVR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 22:21:17 -0400
In-Reply-To: <20050613222527.GB8629@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gregoire Favre <gregoire.favre@gmail.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, 2005-06-14 at 00:25 +0200, Gregoire Favre wrote:
> Yes, due to those problem, I have reduced all devices speed on both
> controllers. Now I think I can put the HD to 160 and my CD-writers to
> 20 :-) (Maybe I could try to also put the DVD-Rom to 20).

Actually, I think the problem is that the DVD-Rom thinks it can run at
20 but actually can't

> Do you think it's safe to use this patched 2.6.12-rc6 (I could stay
> under 2.6.12-rc2 till 2.6.12-rc7 or 2.6.12 comes out) ?

Well ... look at it this way ... if no-one finds anything wrong with the
patches, they'll be going straight into the kernel tree after 2.6.12, so
I trust them as much as that ...

James


