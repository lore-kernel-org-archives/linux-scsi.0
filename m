From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 09 Jul 2005 19:57:29 +0200
Message-ID: <1120931849.3176.54.camel@laptopd505.fenrus.org>
References: <20050709162712.GB27347@phunnypharm.org>
	 <200507091700.j69H0q5Y029204@einhorn.in-berlin.de>
	 <20050709175118.GB29099@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:9395 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261650AbVGIR5l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Jul 2005 13:57:41 -0400
In-Reply-To: <20050709175118.GB29099@phunnypharm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Sat, 2005-07-09 at 13:51 -0400, Ben Collins wrote:
> On Sat, Jul 09, 2005 at 07:00:52PM +0200, Stefan Richter wrote:
> > On  9 Jul, Ben Collins wrote:
> > > If it was orphaned it was done so mistakenly. I maintain that code, and
> > > linux1394.
> > 
> > sbp2 and eth1394 have been listed as orphan since linux-2.6.12.
> 
> Can't see how the most used driver in our repo can be considered orphaned.
> I'm a little irritated that the change occured. I've sent a patch to Linus
> to put SBP2 back under my name.

did you also send him the changes you have pending in these drivers (if
any) to him ? Or maybe sbp2 should go via james since it is a scsi
driver....


