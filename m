From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] debloat aic7xxx and aic79xx drivers by deinlining
Date: Thu, 30 Aug 2007 13:02:35 -0600
Message-ID: <20070830190235.GX14130@parisc-linux.org>
References: <200708252257.07241.vda.linux@googlemail.com> <200708281256.35162.vda.linux@googlemail.com> <20070828081710.4687185c@laptopd505.fenrus.org> <200708282055.07411.vda.linux@googlemail.com> <Pine.LNX.4.64.0708302042260.24730@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47893 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635AbXH3TCg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Aug 2007 15:02:36 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708302042260.24730@fbirervta.pbzchgretzou.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de

On Thu, Aug 30, 2007 at 08:43:24PM +0200, Jan Engelhardt wrote:
> On Aug 28 2007 20:55, Denys Vlasenko wrote:
> >> Fwiw I do like your debloat patch a lot; it's just only half the
> >> equation ... if you also do the namespace fixes, I bet the driver
> >> debloats even more...
> >
> >Yes, I know, and I am happy to do that too. I just don't know
> >whether patches will be accepted.
> >
> >Why this patch is not commented on by scsi people?
> >Am I sending patches to wrong people/lists?
> 
> Well, you can send it to Linus/Andrew, that will usually upset people and they
> start commenting on it. Or they don't, and everything is fine.
> (The "default y" approach so to speak ;-)

The problem is that we don't really have a maintainer for the aic7xyz
drivers any more.  Volunteers welcome.  NOT IT!

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
